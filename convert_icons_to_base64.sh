#!/bin/bash
# Script to convert PNG icons to base64 strings for embedding

ICONS_DIR="icons"
OUTPUT_FILE="icons_base64.json"

if [ ! -d "$ICONS_DIR" ]; then
  echo "Error: $ICONS_DIR directory not found"
  echo "Please create the icons directory and add your PNG files"
  exit 1
fi

echo "Converting icons to base64..."
echo "{" > "$OUTPUT_FILE"

first=true
for icon in "$ICONS_DIR"/*.png; do
  if [ -f "$icon" ]; then
    icon_name=$(basename "$icon" .png)
    base64_string=$(base64 -i "$icon")
    
    if [ "$first" = true ]; then
      first=false
    else
      echo "," >> "$OUTPUT_FILE"
    fi
    
    echo -n "  \"$icon_name\": \"data:image/png;base64,$base64_string\"" >> "$OUTPUT_FILE"
    echo "✅ Converted: $icon_name"
  fi
done

echo "" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo ""
echo "✅ Base64 conversion complete: $OUTPUT_FILE"
echo ""
echo "You can now copy the contents of $OUTPUT_FILE into your Liquid templates"

