#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rm -rf "$ROOT/.trmnl-dev" "$ROOT/_build"

echo "Removed local TRMNLP runtime and build output."
