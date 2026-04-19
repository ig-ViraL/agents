#!/usr/bin/env bash
# Install Viral's custom Claude Code agents.
#
# Usage (run from the cloned repo root):
#   ./install.sh                              # global install to ~/.claude/  (recommended)
#   ./install.sh --project /path/to/project   # install into a specific project
#   ./install.sh --help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$SCRIPT_DIR/.claude/agents"

MODE="global"
TARGET=""

usage() {
  cat <<EOF
Usage: ./install.sh [options]

Install Viral's custom Claude Code agents.

Options:
  (no args)              Install globally to ~/.claude/  (recommended)
  --project <path>       Install into a specific project's .claude/ folder
  -h, --help             Show this help

Examples:
  ./install.sh
  ./install.sh --project ~/code/my-app
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)  MODE="project"; TARGET="${2:-}"; shift 2 ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ ! -d "$AGENTS_SRC" ]]; then
  echo "❌ Could not find $AGENTS_SRC" >&2
  echo "   Run this script from the cloned repo root." >&2
  exit 1
fi

if [[ "$MODE" == "global" ]]; then
  DEST_AGENTS="$HOME/.claude/agents"
  echo "🌍 Global install → $HOME/.claude/agents"
else
  if [[ -z "$TARGET" ]]; then
    echo "❌ --project requires a path" >&2; exit 1
  fi
  if [[ ! -d "$TARGET" ]]; then
    echo "❌ Target is not a directory: $TARGET" >&2; exit 1
  fi
  TARGET="$(cd "$TARGET" && pwd)"
  DEST_AGENTS="$TARGET/.claude/agents"
  echo "📁 Project install → $TARGET"
fi

mkdir -p "$DEST_AGENTS"
AGENT_COUNT=0
for f in "$AGENTS_SRC"/*.md; do
  [[ -e "$f" ]] || continue
  cp "$f" "$DEST_AGENTS/"
  AGENT_COUNT=$((AGENT_COUNT + 1))
done
echo "✅ Copied $AGENT_COUNT agent(s) to $DEST_AGENTS"

if [[ "$MODE" == "project" ]]; then
  GITIGNORE="$TARGET/.gitignore"
  touch "$GITIGNORE"
  ENTRIES=(".claude/agents/" "viral-agents.md")
  ADDED=0
  for entry in "${ENTRIES[@]}"; do
    if ! grep -qxF "$entry" "$GITIGNORE"; then
      echo "$entry" >> "$GITIGNORE"
      ADDED=$((ADDED + 1))
    fi
  done
  if [[ $ADDED -gt 0 ]]; then
    echo "✅ Added $ADDED entry(s) to $GITIGNORE"
  else
    echo "ℹ️  .gitignore already has the needed entries"
  fi
fi

echo ""
echo "🎉 Done."
echo "   Next: open Claude Code in your project and run the 'project-scout' agent"
echo "   to generate viral-agents.md."
