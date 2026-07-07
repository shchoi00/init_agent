#!/usr/bin/env bash
set -euo pipefail

SUBAGENTS_REPO="https://github.com/VoltAgent/awesome-codex-subagents.git"
SUBAGENTS_BRANCH="add-categories"
AGENTS_DIR="${CODEX_HOME:-$HOME/.codex}/agents"
TMP_DIR=""

AI_AGENTS=(
  ai-engineer
  llm-architect
  machine-learning-engineer
  ml-engineer
  mlops-engineer
  nlp-engineer
  data-engineer
  data-scientist
  prompt-engineer
)

QUALITY_AGENTS=(
  python-pro
  reviewer
  debugger
)

add_codex_alias() {
  local shell_rc=""

  if [ -n "${ZSH_VERSION:-}" ]; then
    shell_rc="$HOME/.zshrc"
  elif [ -n "${BASH_VERSION:-}" ]; then
    shell_rc="$HOME/.bashrc"
  elif [ -f "$HOME/.bashrc" ]; then
    shell_rc="$HOME/.bashrc"
  elif [ -f "$HOME/.zshrc" ]; then
    shell_rc="$HOME/.zshrc"
  else
    shell_rc="$HOME/.bashrc"
  fi

  touch "$shell_rc"

  if grep -Eq 'alias codex=.*codex --sandbox danger-full-access' "$shell_rc"; then
    echo "alias already configured in $shell_rc"
    return
  fi

  {
    echo
    echo '# init_agent: run Codex with full workspace access by default.'
    echo 'alias codex="codex --sandbox danger-full-access"'
  } >> "$shell_rc"

  echo "added Codex alias to $shell_rc"
  echo "run: source $shell_rc"
}

copy_agent_without_model_pin() {
  local src="$1"
  local dest="$2"

  if [ ! -f "$src" ]; then
    echo "missing agent source: $src" >&2
    return 1
  fi

  grep -v '^model = ' "$src" > "$dest"
}

cleanup() {
  if [ -n "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}

main() {
  TMP_DIR="$(mktemp -d)"
  trap cleanup EXIT

  if ! command -v git >/dev/null 2>&1; then
    echo "git is required" >&2
    exit 1
  fi

  if ! command -v codex >/dev/null 2>&1; then
    echo "warning: codex is not currently on PATH" >&2
  fi

  add_codex_alias

  git clone --depth 1 --branch "$SUBAGENTS_BRANCH" "$SUBAGENTS_REPO" "$TMP_DIR/awesome-codex-subagents"

  mkdir -p "$AGENTS_DIR"

  local agent
  for agent in "${AI_AGENTS[@]}"; do
    copy_agent_without_model_pin \
      "$TMP_DIR/awesome-codex-subagents/categories/05-data-ai/${agent}.toml" \
      "$AGENTS_DIR/${agent}.toml"
  done

  for agent in "${QUALITY_AGENTS[@]}"; do
    if [ -f "$TMP_DIR/awesome-codex-subagents/categories/02-language-specialists/${agent}.toml" ]; then
      copy_agent_without_model_pin \
        "$TMP_DIR/awesome-codex-subagents/categories/02-language-specialists/${agent}.toml" \
        "$AGENTS_DIR/${agent}.toml"
    elif [ -f "$TMP_DIR/awesome-codex-subagents/categories/04-quality-security/${agent}.toml" ]; then
      copy_agent_without_model_pin \
        "$TMP_DIR/awesome-codex-subagents/categories/04-quality-security/${agent}.toml" \
        "$AGENTS_DIR/${agent}.toml"
    else
      echo "missing quality agent: $agent" >&2
      exit 1
    fi
  done

  echo
  echo "installed agents:"
  ls -1 "$AGENTS_DIR"

  echo
  command -v codex || true
  echo "model pins removed from installed agents:"
  if grep -R '^model = ' "$AGENTS_DIR"/*.toml >/dev/null 2>&1; then
    grep -R '^model = ' "$AGENTS_DIR"/*.toml
    exit 1
  fi
  echo "ok"
}

main "$@"
