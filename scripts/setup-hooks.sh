#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
chmod +x "$ROOT/.githooks/prepare-commit-msg"
git -C "$ROOT" config core.hooksPath .githooks

echo "Git hooks installed. co-author lines will be removed from commits."
