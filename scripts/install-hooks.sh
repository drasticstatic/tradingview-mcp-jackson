#!/bin/sh
# Activate this repo's version-controlled git hooks.
#
# Git hooks live in .git/hooks/, which is NOT version-controlled — so a committed
# hook does nothing until each clone is pointed at .githooks/. This script does
# that. Run it once per clone, per machine:
#
#     sh scripts/install-hooks.sh
#
# Safe to re-run. Every agent working in this repo should run it after cloning.

set -e

cd "$(git rev-parse --show-toplevel)"

if [ ! -d .githooks ]; then
  echo "✗ No .githooks/ directory here. Copy it from my-template first." >&2
  exit 1
fi

chmod +x .githooks/* 2>/dev/null || true

PREV=$(git config --get core.hooksPath || echo "")
if [ "$PREV" = ".githooks" ]; then
  echo "✓ core.hooksPath already set to .githooks"
else
  if [ -n "$PREV" ]; then
    echo "⚠ core.hooksPath was '$PREV' — overriding with .githooks"
  fi
  git config core.hooksPath .githooks
  echo "✓ core.hooksPath set to .githooks"
fi

echo ""
echo "Active hooks:"
for h in .githooks/*; do
  [ -f "$h" ] && echo "  · $(basename "$h")"
done
echo ""
echo "commit-msg now enforces the fleet attribution convention."
echo "See AGENT-SYNC/README.md. Human-only commits: git commit --no-verify"
