#!/usr/bin/env bash
# Run from inside any git repo to wire up git-foundry's shared hooks for that
# repo only (local git config, not --global, so other repos are untouched).
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: not inside a git repo. cd into the target repo and re-run." >&2
  exit 1
fi

hooks_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hooks"

git config core.hooksPath "$hooks_dir"
echo "git-foundry hooks installed for $(git rev-parse --show-toplevel) -> $hooks_dir"
