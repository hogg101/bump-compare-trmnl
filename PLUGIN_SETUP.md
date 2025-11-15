# Bump Compare - Plugin Setup Guide

## Overview

This is a TRMNL v2 Private Plugin that displays the current gestational week and compares it to fruit/vegetable sizes.

## Installation

1. **Create a Private Plugin** in your TRMNL dashboard
2. **Import the plugin files**:
   - Upload `settings.yml` (or create plugin and upload files via ZIP import)
   - Upload `full.liquid`, `half_horizontal.liquid`, `half_vertical.liquid`, `quadrant.liquid` to their respective viewport sections
   - Set up custom fields by pasting YAML from `custom_fields.yml` into the custom fields editor
   - Icons are embedded as SVG in the markup (no separate upload needed)

## Custom Fields Setup

Use TRMNL's custom form builder to create these fields:

- **due_month** (text): Optional, format `YYYY-MM` (e.g., `2024-09`)
- **due_date** (text): Optional, format `YYYY-MM-DD` (e.g., `2024-09-15`). Overrides `due_month` if set
- **month_anchor_day** (number): Default `15`. Used when only `due_month` is provided
- **locale** (select): `en-GB` (UK English) or `en-US` (US English). Default: `en-GB`
- **units** (select): `metric` or `imperial`. Default: `metric` (auto-set from locale if not specified)

## Icon Assets

Icons are embedded as SVG directly in the Liquid markup files. This means:
- **No separate upload needed** - icons are part of the markup
- **No external hosting required** - no URLs, no CDN, no file hosting
- **No external network calls** - everything is self-contained in the markup
- **Works completely offline** - icons are embedded inline in the template code
- **20 icons total** - see `ICONS.md` for complete list

### Creating Icons

Icons should be:
- **SVG** format (Scalable Vector Graphics)
- **Vector-based** - scalable to any size without quality loss
- **Bold silhouettes** suitable for e-ink displays
- **Monochrome/1-bit style** - simple shapes optimized for e-ink
- Named according to the `icon` field in the weeks data (e.g., `poppy.svg`, `raspberry.svg`)

### Creating SVG Icons

You can create SVG icons using:
- Vector graphics software (Illustrator, Inkscape, Figma, etc.)
- Code editors (hand-written SVG)
- Convert from other formats and simplify to vector paths

SVG icons should use simple paths and shapes, avoiding complex gradients or effects for best e-ink display.

### Embedding Icons as SVG

Once icons are created, embed them directly in the Liquid templates:
- **No hosting needed** - icons are embedded directly in the markup files
- **Inline SVG**: Open your SVG file, copy the entire `<svg>...</svg>` markup, and paste it directly into the Liquid template
- Icons become part of the markup itself - no file references, no URLs, no external hosting

**Example workflow:**
1. Create `poppy.svg` file
2. Open `poppy.svg` in a text editor
3. Copy the entire SVG markup (everything from `<svg` to `</svg>`)
4. Paste it into your Liquid template where the icon should appear
5. Store it in a variable or data structure for reuse

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

1. Create the icon as an SVG file
2. Embed the SVG markup directly in all Liquid template files (`full.liquid`, `half_horizontal.liquid`, etc.)
3. Update the weeks data to reference the new icon
4. Add the SVG markup to the icon data structure in the templates

## Interpolation

For weeks between anchor points (e.g., week 5, 6, 7 between poppy seed at week 4 and raspberry at week 8), the plugin uses the nearest lower anchor week. Future versions may interpolate sizes linearly.

## Testing

- Test with different due dates to verify week calculations
- Test locale switching (en-GB vs en-US)
- Test unit conversion (metric vs imperial)
- Verify icons display correctly on e-ink preview
- Test with missing due date (should show helpful message)

