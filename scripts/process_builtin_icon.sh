#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 /path/to/generated-icon.png output-name.png" >&2
  exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick 'magick' not found in PATH." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$1"
NAME="$2"
OUT_DIR="$ROOT/output/imagegen/bump-icons-individual"
KEYED_DIR="$OUT_DIR/keyed"
TRANSPARENT_DIR="$OUT_DIR/transparent"

if [[ ! -f "$SRC" ]]; then
  echo "Generated icon not found: $SRC" >&2
  exit 1
fi

mkdir -p "$KEYED_DIR" "$TRANSPARENT_DIR"

cp "$SRC" "$KEYED_DIR/$NAME"

magick "$SRC" \
  -alpha set \
  -channel A -fx "((r>0.08)&&(b>0.08)&&(g<0.26)&&(abs(r-b)<0.42))?0:a" +channel \
  -colorspace Gray \
  -trim +repage \
  "$TRANSPARENT_DIR/$NAME"

echo "$TRANSPARENT_DIR/$NAME"
