#!/bin/bash

set -euo pipefail

# This helper is intentionally narrow: it links the owned-source repository
# to one explicit destination without touching the shared runtime aggregator.
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET_PATH="${1:-}"

if [ -z "$TARGET_PATH" ]; then
  echo "Usage: $0 <target-path>" >&2
  echo "This helper links only the owned skills repository to one explicit target." >&2
  echo "For the machine-wide aggregated install layer, use /Users/liuwei/workspace/dotfiles/agents/skills/install.sh." >&2
  exit 1
fi

# Replace the target path in place so a single runtime can point directly at
# this repository without changing the machine-wide shared install layer.
mkdir -p "$(dirname "$TARGET_PATH")"
rm -rf "$TARGET_PATH"
ln -s "$REPO_ROOT" "$TARGET_PATH"

echo "Linked $TARGET_PATH -> $REPO_ROOT"
