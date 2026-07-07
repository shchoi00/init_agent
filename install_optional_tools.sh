#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN_DIR="$HOME/.local/bin"
NODE_INSTALL_ROOT="$HOME/.local/share/init_agent/node"
NODE_MAJOR="${NODE_MAJOR:-22}"

export PATH="$LOCAL_BIN_DIR:$PATH"

usage() {
  cat <<'EOF'
Usage: bash install_optional_tools.sh [all|docs-mcp|project-skill|project-hooks|omx]

Options:
  all            Install the lightweight optional local tools/templates.
  docs-mcp       Add the official OpenAI Developer Docs MCP server.
  project-skill  Install the project workflow skill template.
  project-hooks  Copy hook/config templates into .codex/.
  omx            Install the optional Oh My Codex workflow layer.
EOF
}

install_docs_mcp() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "codex is required to install MCP servers" >&2
    exit 1
  fi

  if codex mcp list | grep -q '^openaiDeveloperDocs[[:space:]]'; then
    echo "OpenAI Developer Docs MCP is already configured."
    return
  fi

  codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
}

install_project_skill() {
  local skills_dir="$CODEX_HOME_DIR/skills"
  mkdir -p "$skills_dir"
  cp -R "$SCRIPT_DIR/templates/skills/physicalai-hdmap-workflow" "$skills_dir/"
  echo "Installed skill: $skills_dir/physicalai-hdmap-workflow"
}

install_project_hooks() {
  mkdir -p "$SCRIPT_DIR/.codex/hooks"

  cp "$SCRIPT_DIR/templates/project-codex/config.toml" "$SCRIPT_DIR/.codex/config.toml"
  cp "$SCRIPT_DIR/templates/hooks/pre_tool_use_policy.py" "$SCRIPT_DIR/.codex/hooks/pre_tool_use_policy.py"
  chmod +x "$SCRIPT_DIR/.codex/hooks/pre_tool_use_policy.py"

  echo "Copied project Codex config and hook template into $SCRIPT_DIR/.codex/"
  echo "Review and trust the project config before relying on hooks."
}

node_major_version() {
  if command -v node >/dev/null 2>&1; then
    node -p 'process.versions.node.split(".")[0]' 2>/dev/null || true
  fi
}

install_local_node() {
  local os arch platform sums filename tmp_dir extracted_dir

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install Node.js locally" >&2
    exit 1
  fi

  os="$(uname -s)"
  arch="$(uname -m)"
  case "$os:$arch" in
    Linux:x86_64) platform="linux-x64" ;;
    Linux:aarch64|Linux:arm64) platform="linux-arm64" ;;
    Darwin:x86_64) platform="darwin-x64" ;;
    Darwin:arm64) platform="darwin-arm64" ;;
    *)
      echo "Unsupported Node.js auto-install platform: $os $arch" >&2
      exit 1
      ;;
  esac

  mkdir -p "$NODE_INSTALL_ROOT" "$LOCAL_BIN_DIR"

  sums="$(curl -fsSL "https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/SHASUMS256.txt")"
  filename="$(printf '%s\n' "$sums" | awk -v platform="$platform" '$2 ~ "^node-v.*-" platform "\\.tar\\.xz$" {print $2; exit}')"
  if [ -z "$filename" ]; then
    echo "Could not find Node.js ${NODE_MAJOR}.x archive for $platform" >&2
    exit 1
  fi

  tmp_dir="$(mktemp -d)"

  echo "Installing Node.js ${NODE_MAJOR}.x locally from $filename"
  curl -fsSL -o "$tmp_dir/$filename" "https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/$filename"
  tar -xJf "$tmp_dir/$filename" -C "$NODE_INSTALL_ROOT"

  extracted_dir="${filename%.tar.xz}"
  ln -sfn "$NODE_INSTALL_ROOT/$extracted_dir" "$NODE_INSTALL_ROOT/current"
  ln -sfn "$NODE_INSTALL_ROOT/current/bin/node" "$LOCAL_BIN_DIR/node"
  ln -sfn "$NODE_INSTALL_ROOT/current/bin/npm" "$LOCAL_BIN_DIR/npm"
  ln -sfn "$NODE_INSTALL_ROOT/current/bin/npx" "$LOCAL_BIN_DIR/npx"
  if [ -x "$NODE_INSTALL_ROOT/current/bin/corepack" ]; then
    ln -sfn "$NODE_INSTALL_ROOT/current/bin/corepack" "$LOCAL_BIN_DIR/corepack"
  fi

  rm -rf "$tmp_dir"
}

ensure_node() {
  local node_major
  node_major="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || true)"

  if [ -n "$node_major" ] && [ "$node_major" -ge 20 ] && command -v npm >/dev/null 2>&1; then
    return
  fi

  install_local_node
  hash -r

  node_major="$(node_major_version)"
  if [ -z "$node_major" ] || [ "$node_major" -lt 20 ] || ! command -v npm >/dev/null 2>&1; then
    echo "Node.js 20+ and npm are required for OMX; install failed" >&2
    exit 1
  fi
}

install_omx() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "codex is required before installing OMX" >&2
    exit 1
  fi

  ensure_node

  NPM_CONFIG_PREFIX="$HOME/.local" npm install -g oh-my-codex

  if command -v omx >/dev/null 2>&1; then
    if [ "${OMX_SKIP_SETUP:-0}" != "1" ]; then
      local setup_scope setup_mode
      setup_scope="${OMX_SETUP_SCOPE:-user}"
      setup_mode="${OMX_SETUP_MODE:-plugin}"

      case "$setup_scope" in
        user|project) ;;
        *)
          echo "Unsupported OMX_SETUP_SCOPE: $setup_scope" >&2
          exit 1
          ;;
      esac

      case "$setup_mode" in
        plugin|legacy) ;;
        *)
          echo "Unsupported OMX_SETUP_MODE: $setup_mode" >&2
          exit 1
          ;;
      esac

      local -a setup_args
      setup_args=(setup --scope "$setup_scope" "--$setup_mode")

      if [ "${OMX_SETUP_FORCE:-auto}" = "1" ] \
        || { [ "${OMX_SETUP_FORCE:-auto}" = "auto" ] && [ "$setup_scope" = "user" ] && [ ! -f "$CODEX_HOME_DIR/AGENTS.md" ]; }; then
        setup_args+=(--force)
      else
        setup_args+=(--merge-agents)
      fi

      omx "${setup_args[@]}"
    fi

    omx doctor
    cat <<'EOF'

OMX is installed and verified.

Default setup:
  omx setup --scope user --plugin

Override examples:
  OMX_SETUP_SCOPE=project bash install_optional_tools.sh omx
  OMX_SKIP_SETUP=1 bash install_optional_tools.sh omx
EOF
  else
    echo "OMX install finished, but 'omx' is not on PATH. Check npm global bin." >&2
    exit 1
  fi
}

main() {
  local target="${1:-all}"

  case "$target" in
    all)
      install_docs_mcp
      install_project_skill
      install_project_hooks
      ;;
    docs-mcp)
      install_docs_mcp
      ;;
    project-skill)
      install_project_skill
      ;;
    project-hooks)
      install_project_hooks
      ;;
    omx)
      install_omx
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
