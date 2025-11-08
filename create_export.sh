#!/bin/bash
# Script to create an exportable ZIP package for TRMNL plugin

PLUGIN_NAME="bump-compare-trmnl"
VERSION="1.0.0"
EXPORT_DIR="export"
ZIP_NAME="${PLUGIN_NAME}-v${VERSION}.zip"

echo "Creating export package for ${PLUGIN_NAME}..."

# Create export directory
mkdir -p "${EXPORT_DIR}"

# Copy required files
cp settings.yml "${EXPORT_DIR}/"
cp full.liquid "${EXPORT_DIR}/"
cp half_horizontal.liquid "${EXPORT_DIR}/"
cp half_vertical.liquid "${EXPORT_DIR}/"
cp quadrant.liquid "${EXPORT_DIR}/"

# Copy icons if they exist
if [ -d "icons" ]; then
  echo "Including icons directory..."
  cp -r icons "${EXPORT_DIR}/"
else
  echo "Warning: icons directory not found. Icons will need to be added separately."
fi

# Copy documentation (optional, for reference)
cp README.md "${EXPORT_DIR}/" 2>/dev/null || true
cp custom_fields.yml "${EXPORT_DIR}/" 2>/dev/null || true

# Create ZIP
cd "${EXPORT_DIR}"
zip -r "../${ZIP_NAME}" . -x "*.DS_Store" "*.git*"
cd ..

# Clean up
rm -rf "${EXPORT_DIR}"

echo "✅ Export package created: ${ZIP_NAME}"
echo ""
echo "Files included:"
unzip -l "${ZIP_NAME}" | grep -E "\.(yml|liquid|png)$" | head -20

