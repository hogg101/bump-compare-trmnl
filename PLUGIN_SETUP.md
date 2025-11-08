# Bump Compare - Plugin Setup Guide

## Overview

This is a TRMNL v2 Private Plugin that displays the current gestational week and compares it to fruit/vegetable sizes.

## Installation

1. **Create a Private Plugin** in your TRMNL dashboard
2. **Import the plugin files**:
   - Upload `settings.yml` (or create plugin and upload files via ZIP import)
   - Upload `full.liquid`, `half_horizontal.liquid`, `half_vertical.liquid`, `quadrant.liquid` to their respective viewport sections
   - Set up custom fields by pasting YAML from `custom_fields.yml` into the custom fields editor
   - Icons are embedded as base64 in the markup (no separate upload needed)

## Custom Fields Setup

Use TRMNL's custom form builder to create these fields:

- **due_month** (text): Optional, format `YYYY-MM` (e.g., `2024-09`)
- **due_date** (text): Optional, format `YYYY-MM-DD` (e.g., `2024-09-15`). Overrides `due_month` if set
- **month_anchor_day** (number): Default `15`. Used when only `due_month` is provided
- **locale** (select): `en-GB` (UK English) or `en-US` (US English). Default: `en-GB`
- **units** (select): `metric` or `imperial`. Default: `metric` (auto-set from locale if not specified)

## Icon Assets

Icons are embedded as base64 strings directly in the Liquid markup files. This means:
- **No separate upload needed** - icons are part of the markup
- **No external hosting required** - works offline
- **20 icons total** - see `ICONS.md` for complete list

### Creating Icons

Icons should be:
- **1-bit PNG** format
- **~256×256 pixels** (or higher, will be scaled)
- **Bold silhouettes** suitable for e-ink displays
- Named according to the `icon` field in the weeks data (e.g., `poppy.png`, `raspberry.png`)

### Converting Images to 1-bit

You can use ImageMagick to convert images:

```bash
convert input.png -monochrome -resize 256x256 output.png
```

Or with dithering:

```bash
convert input.png -colors 2 -ordered-dither o8x8 -resize 256x256 output.png
```

### Embedding Icons as Base64

Once icons are created, use the provided script to convert them to base64:

```bash
./convert_icons_to_base64.sh
```

Then update the Liquid templates to include the base64 strings. See `ASSET_STRATEGY.md` for details.

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

1. Create the icon as a 1-bit PNG
2. Convert to base64 using `convert_icons_to_base64.sh`
3. Update the weeks data in all Liquid template files (`full.liquid`, `half_horizontal.liquid`, etc.)
4. Add the base64 string to the icon data structure in the templates

## Interpolation

For weeks between anchor points (e.g., week 5, 6, 7 between poppy seed at week 4 and raspberry at week 8), the plugin uses the nearest lower anchor week. Future versions may interpolate sizes linearly.

## Testing

- Test with different due dates to verify week calculations
- Test locale switching (en-GB vs en-US)
- Test unit conversion (metric vs imperial)
- Verify icons display correctly on e-ink preview
- Test with missing due date (should show helpful message)

