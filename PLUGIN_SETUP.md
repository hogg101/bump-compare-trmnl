# Bump Compare - Plugin Setup Guide

## Overview

This is a TRMNL v2 Private Plugin that displays the current gestational week and compares it to fruit/vegetable sizes.

## Installation

1. **Create a Private Plugin** in your TRMNL dashboard
2. **Import the plugin files**:
   - Copy the contents of `markup.liquid` into the main markup field
   - Set up custom fields using the schema in `custom-fields.json`
   - Upload icon files to the plugin's asset manager

## Custom Fields Setup

Use TRMNL's custom form builder to create these fields:

- **due_month** (text): Optional, format `YYYY-MM` (e.g., `2024-09`)
- **due_date** (text): Optional, format `YYYY-MM-DD` (e.g., `2024-09-15`). Overrides `due_month` if set
- **month_anchor_day** (number): Default `15`. Used when only `due_month` is provided
- **locale** (select): `en-GB` (UK English) or `en-US` (US English). Default: `en-GB`
- **units** (select): `metric` or `imperial`. Default: `metric` (auto-set from locale if not specified)

## Icon Assets

Icons should be:
- **1-bit PNG** format
- **~256×256 pixels**
- **Bold silhouettes** suitable for e-ink displays
- Named according to the `icon` field in `weeks.json` (e.g., `poppy.png`, `raspberry.png`)

### Converting Images to 1-bit

You can use ImageMagick to convert images:

```bash
convert input.png -monochrome -resize 256x256 output.png
```

Or with dithering:

```bash
convert input.png -colors 2 -ordered-dither o8x8 -resize 256x256 output.png
```

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

1. Update `weeks.json` with new week entries or modify existing ones
2. Add the corresponding icon file to the plugin's assets
3. Update the embedded JSON in `markup.liquid` to match `weeks.json`

## Interpolation

For weeks between anchor points (e.g., week 5, 6, 7 between poppy seed at week 4 and raspberry at week 8), the plugin uses the nearest lower anchor week. Future versions may interpolate sizes linearly.

## Testing

- Test with different due dates to verify week calculations
- Test locale switching (en-GB vs en-US)
- Test unit conversion (metric vs imperial)
- Verify icons display correctly on e-ink preview
- Test with missing due date (should show helpful message)

