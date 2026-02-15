#!/usr/bin/env bash
set -euo pipefail

# Remove near-white background connected to image borders, then trim empty edges.
# This avoids removing internal highlights that are not edge-connected.

INPUT_DIR="${1:-images}"
OUTPUT_DIR="${2:-images_clean}"
FUZZ="${3:-6%}"
TRIM_FUZZ="${4:-1%}"

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick 'magick' not found in PATH." >&2
  exit 1
fi

if [[ ! -d "$INPUT_DIR" ]]; then
  echo "Input directory not found: $INPUT_DIR" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
files=("$INPUT_DIR"/*.png)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "No PNG files found in: $INPUT_DIR" >&2
  exit 1
fi

for file in "${files[@]}"; do
  base="$(basename "$file")"
  out="$OUTPUT_DIR/$base"

  magick "$file" \
    -alpha set \
    -fuzz "$FUZZ" \
    -fill none \
    -floodfill +0+0 white \
    -floodfill +0-1 white \
    -floodfill -1+0 white \
    -floodfill -1-1 white \
    -fuzz "$TRIM_FUZZ" \
    -trim +repage \
    "$out"

  echo "cleaned: $base"
done

echo "Done. Cleaned files written to: $OUTPUT_DIR"
