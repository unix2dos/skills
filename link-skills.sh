#!/bin/bash

set -euo pipefail

SKILLS_DIR="${1:-$HOME/workspace/skills}"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: skills directory not found: $SKILLS_DIR" >&2
  exit 1
fi

LINK_PATHS=(
  "$HOME/.config/opencode/skill"
  "$HOME/.claude/skills"
  "$HOME/.config/alma/skills"
  "$HOME/.gemini/antigravity/skills"
  "$HOME/.codex/skills"
)

for LINK_PATH in "${LINK_PATHS[@]}"; do
  PARENT_DIR="$(dirname "$LINK_PATH")"
  mkdir -p "$PARENT_DIR"

  if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
    rm -rf "$LINK_PATH"
  fi

  ln -s "$SKILLS_DIR" "$LINK_PATH"
  echo "Linked $LINK_PATH -> $SKILLS_DIR"
done
