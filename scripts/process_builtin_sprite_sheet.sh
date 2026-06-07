#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 /path/to/sprite-sheet.png [output-dir]" >&2
  exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick 'magick' not found in PATH." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$1"
OUT_DIR="${2:-$ROOT/output/imagegen/bump-icons-built-in}"
KEYED_DIR="$OUT_DIR/keyed"
TRANSPARENT_DIR="$OUT_DIR/transparent"
CONTACT_TMP="$ROOT/tmp/imagegen/built-in-contact"

if [[ ! -f "$SRC" ]]; then
  echo "Sprite sheet not found: $SRC" >&2
  exit 1
fi

files=(
  microscope.png poppyseed.png sesameseed.png pea.png blueberry.png
  raspberry.png grape.png olive.png fig.png lime.png
  lemon.png nectarine.png apple.png avocado.png pomegranate.png
  artichoke.png mango.png grapefruit.png swede.png papaya.png
  aubergine.png courgette.png pointedcabbage.png roundlettuce.png redcabbage.png
  cauliflower.png savoycabbage.png butternutsquash.png coconut.png pineapple.png
  cantaloupemelon.png galiamelon.png honeydewmelon.png spaghettisquash.png crownprincesquash.png
  marrow.png watermelon.png pumpkin.png
)

mkdir -p "$KEYED_DIR" "$TRANSPARENT_DIR" "$CONTACT_TMP/cells" "$CONTACT_TMP/rows"
cp "$SRC" "$OUT_DIR/sprite-sheet-keyed.png"

dimensions="$(magick identify -format "%w %h" "$SRC")"
read -r width height <<< "$dimensions"
cell_w=$(( (width + 2) / 5 ))
cell_h=$(( (height + 4) / 8 ))

for i in "${!files[@]}"; do
  col=$((i % 5))
  row=$((i / 5))
  x=$((col * cell_w))
  y=$((row * cell_h))
  keyed="$KEYED_DIR/${files[$i]}"
  final="$TRANSPARENT_DIR/${files[$i]}"

  magick "$SRC" -crop "${cell_w}x${cell_h}+${x}+${y}" +repage "$keyed"
  magick "$keyed" \
    -alpha set \
    -channel A -fx "((r>0.08)&&(b>0.08)&&(g<0.24)&&(abs(r-b)<0.40))?0:a" +channel \
    -colorspace Gray \
    -trim +repage \
    "$final"
done

rm -rf "$CONTACT_TMP"
mkdir -p "$CONTACT_TMP/cells" "$CONTACT_TMP/rows"

for i in "${!files[@]}"; do
  printf -v idx "%02d" "$i"
  magick "$TRANSPARENT_DIR/${files[$i]}" \
    -background white \
    -gravity center \
    -resize 80x80 \
    -extent 96x96 \
    "$CONTACT_TMP/cells/$idx.png"
done

for row in 0 1 2 3 4; do
  start=$((row * 8))
  row_files=()

  for col in 0 1 2 3 4 5 6 7; do
    idx=$((start + col))
    if ((idx < ${#files[@]})); then
      printf -v name "%02d.png" "$idx"
      row_files+=("$CONTACT_TMP/cells/$name")
    else
      blank="$CONTACT_TMP/cells/blank-$idx.png"
      magick -size 96x96 canvas:white "$blank"
      row_files+=("$blank")
    fi
  done

  magick "${row_files[@]}" +append "$CONTACT_TMP/rows/row-$row.png"
done

magick "$CONTACT_TMP/rows"/row-*.png -append "$OUT_DIR/contact-sheet.png"

echo "Wrote processed icons to $TRANSPARENT_DIR"
echo "Wrote contact sheet to $OUT_DIR/contact-sheet.png"
