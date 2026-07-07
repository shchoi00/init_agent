#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: bash install_optional_tools.sh [all|docs-mcp|project-skill|project-hooks]

Options:
  all            Install every optional local tool/template.
  docs-mcp       Add the official OpenAI Developer Docs MCP server.
  project-skill  Install the project workflow skill template.
  project-hooks  Copy hook/config templates into .codex/.
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
