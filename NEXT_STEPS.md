# Next Steps for Bump Compare Plugin

## ✅ Completed (M1 - Prototype)
- [x] Week calculation logic
- [x] Locale/units toggle
- [x] Custom fields configuration
- [x] All viewport sizes (full, half_horizontal, half_vertical, quadrant)
- [x] Basic v2-compliant layout

## 🎯 Priority: Create 1-bit Icons (M2)

### Required Icons (20 total)
See `ICONS.md` for the complete list of all 20 icons needed (weeks 0-40).

### Icon Specifications
- **Format**: 1-bit PNG
- **Size**: ~256×256 pixels (or higher, will be scaled)
- **Style**: Bold silhouettes, suitable for e-ink displays
- **Naming**: Must match the `icon` field in the weeks data
- **Storage**: Icons will be embedded as base64 in the markup (no external hosting)

### Creating Icons

#### Option 1: ImageMagick Conversion
```bash
# Convert existing images to 1-bit
convert input.png -monochrome -resize 256x256 output.png

# Or with dithering
convert input.png -colors 2 -ordered-dither o8x8 -resize 256x256 output.png
```

#### Option 2: Design Tools
- Use Figma/Sketch to create bold silhouettes
- Export as PNG, then convert to 1-bit using ImageMagick
- Test on e-ink preview to ensure legibility

#### Option 3: Public Domain/Free Resources
- Search for public domain fruit/vegetable silhouettes
- Convert to 1-bit format
- Ensure they're recognizable at small sizes

### Icon Directory Structure
Create an `icons/` directory and place all 20 icons there. See `ICONS.md` for the complete list.

Once created, use `convert_icons_to_base64.sh` to convert them to base64 for embedding in the markup.

## 🔧 Polish & Testing (M3)

### Error States
- [ ] Improve "Set due date in settings" message
- [ ] Add helpful hints when date is missing
- [ ] Validate date format and show clear errors

### Typography Refinements
- [ ] Test font sizes on actual TRMNL device
- [ ] Adjust spacing for quadrant viewport
- [ ] Ensure text is readable at all sizes

### Export Package
- [ ] Create ZIP with all required files:
  - `settings.yml`
  - `full.liquid`
  - `half_horizontal.liquid`
  - `half_vertical.liquid`
  - `quadrant.liquid`
  - `icons/` directory (when ready)
  - `custom_fields.yml` (for reference)
  - `README.md` (for users)

## 🧪 Testing Checklist

- [ ] Test with various due dates (past, present, future)
- [ ] Test locale switching (en-GB vs en-US)
- [ ] Test unit conversion (metric vs imperial)
- [ ] Test all viewport sizes
- [ ] Test with missing due date
- [ ] Test with invalid date format
- [ ] Test on actual TRMNL device (if available)
- [ ] Verify week calculation accuracy

## 📦 Distribution

Once icons are ready:
1. Create final ZIP package
2. Test import/export functionality
3. Document installation steps
4. Share with users

## 🚀 Optional: Cloudflare Worker (M4)

If you want to host icons/data centrally later:
- Set up Cloudflare Worker
- Move icons to CDN
- Update plugin to use remote markup URL

