# Bump Compare - Plugin Setup Guide

## Overview

This is a TRMNL v2 Private Plugin that displays the current gestational week and compares it to fruit/vegetable sizes.

## Installation

1. **Create a Private Plugin** in your TRMNL dashboard
2. **Import the plugin files**:
   - Upload `settings.yml` (or create plugin and upload files via ZIP import)
   - Upload `full.liquid`, `half_horizontal.liquid`, `half_vertical.liquid`, `quadrant.liquid` to their respective viewport sections
   - Set up custom fields by pasting YAML from `custom_fields.yml` into the custom fields editor
   - Icons are hosted as PNGs on GitHub (no uploads to TRMNL)

## Custom Fields Setup

Use TRMNL's custom form builder to create these fields:

- **due_month** (text): Optional, format `YYYY-MM` (e.g., `2024-09`)
- **due_date** (text): Optional, format `YYYY-MM-DD` (e.g., `2024-09-15`). Overrides `due_month` if set
- **month_anchor_day** (number): Default `15`. Used when only `due_month` is provided
- **locale** (select): `en-GB` (UK English) or `en-US` (US English). Default: `en-GB`
- **units** (select): `metric` or `imperial`. Default: `metric` (auto-set from locale if not specified)

## Icon Assets

Icons are hosted as PNG files in the GitHub repo and loaded at runtime. This means:
- **No TRMNL upload needed** - icons live in the repo
- **External hosting required** - icons are fetched from GitHub's CDN
- **Simple updates** - push new PNGs to the repo
- **38 icons total** - see `weeks.md` for complete list

### Creating Icons

Icons should be:
- **PNG** format (1-bit or dithered)
- **Bold silhouettes** suitable for e-ink displays
- **Monochrome/1-bit style** - simple shapes optimized for e-ink
- Named according to the `icon` field in the weeks data (e.g., `poppy.png`, `raspberry.png`)

### Creating PNG Icons

You can create PNG icons using:
- Raster or vector tools (export to PNG from Figma/Illustrator/Inkscape)
- Pixel editors (Aseprite, Photoshop, etc.)
- Convert from other formats and simplify for 1-bit display

PNG icons should be exported with a simple silhouette and high contrast for best e-ink display.

### Hosting Icons on GitHub

Once icons are created, host them in the repo and reference them from Liquid:
- Store PNGs in the `images/` directory
- Set `icon_base_url` in each Liquid template to your GitHub raw URL
- Icons load via `icon_base_url` + filename at runtime

**Example workflow:**
1. Create `poppy.png` file
2. Add it to the `images/` directory in the repo
3. Update `icon_base_url` in each Liquid template
4. Reference `poppy.png` in the weeks data

See `ASSET_STRATEGY.md` for details.

## How It Works

1. **Week Calculation**: The plugin calculates the current gestational week using the formula:
   ```
   week = clamp(floor((280 - days_to_due) / 7), 0, 40)
   ```

2. **Comparator Selection**: Finds the nearest lower week from the data set (or exact match if available)

3. **Unit Conversion**: 
   - Metric: displays mm and g (or mg for very small weights)
   - Imperial: displays inches (1 decimal) and ounces (or lb/oz for larger weights)

4. **Localisation**: Uses the selected locale to display appropriate produce names (e.g., "Aubergine" vs "Eggplant")

## Adding/Replacing Icons

To add or replace icons:

1. Create the icon as a PNG file
2. Add the PNG to the `images/` directory in the repo
3. Update the weeks data to reference the new icon filename
4. Confirm the `icon_base_url` is correct in each Liquid template

## Interpolation

For weeks between anchor points (e.g., week 5, 6, 7 between poppy seed at week 4 and raspberry at week 8), the plugin uses the nearest lower anchor week. Future versions may interpolate sizes linearly.

## Testing

- Test with different due dates to verify week calculations
- Test locale switching (en-GB vs en-US)
- Test unit conversion (metric vs imperial)
- Verify icons display correctly on e-ink preview
- Test with missing due date (should show helpful message)
