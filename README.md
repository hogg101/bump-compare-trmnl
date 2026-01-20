# Project Brief — “Bump Compare” (TRMNL v2 plugin)

## Summary

A single-purpose TRMNL v2 plugin that shows the current gestational week and a **lo-fi 1-bit** fruit/veg comparator. User sets an approximate due date (month or exact date). The plugin calculates the current week automatically and updates each refresh. Logic runs in the plugin’s markup (client-side), while icon PNGs are hosted on GitHub. Optional fallback: Cloudflare Worker if we later decide to centralise data or A/B assets.

## Objectives

* Zero-maintenance deployment (no server to run).
* Clean presentation on TRMNL’s e-ink displays using **Framework v2** components/utilities. ([usetrmnl.com][1])
* UK English + metric and US English + imperial selectable in settings.
* Account for **every week** (0–40, clamped) with a recognisable 1-bit icon and approximate length/weight.
* Friendly upgrade path to a lightweight Worker if needed.

## Scope & Constraints

* **One visual style only**: monochrome, 1-bit bitmaps (with optional dithering). ([help.usetrmnl.com][2])
* **One comparator set** (produce). Keep naming UK-friendly; map US variants in localisation.
* **No backend by default**: use TRMNL Private Plugin markup, custom fields, Liquid, and client-side JS; icons load from GitHub-hosted PNGs. ([usetrmnl.com][3])
* **TRMNL v2**: adopt v2 layout, typography, and stricter markup requirements. ([usetrmnl.com][1])

## User Settings (Custom Fields)

Create via TRMNL’s custom form builder: ([help.usetrmnl.com][4])

* `due_month` (string, `YYYY-MM`) — optional
* `due_date` (string, `YYYY-MM-DD`) — optional; overrides `due_month`
* `month_anchor_day` (int; default `15`) — only used if `due_month` set
* `locale` (`en-GB` | `en-US`; default `en-GB`)
* `units` (`metric` | `imperial`; default auto from `locale`)

TRMNL injects user/timezone variables into the plugin; use these to compute “today”. ([help.usetrmnl.com][5])

## Data Model

Embed a small JSON table inside the markup (avoids hosting). Example schema:

```json
[
  { "week": 4,  "name": { "en-GB": "Poppy seed", "en-US": "Poppy seed" }, "length_mm": 1,   "weight_g": 0.002, "icon": "poppy.png" },
  { "week": 8,  "name": { "en-GB": "Raspberry",  "en-US": "Raspberry"  }, "length_mm": 16,  "weight_g": 1,     "icon": "raspberry.png" },
  { "week": 12, "name": { "en-GB": "Lime",       "en-US": "Lime"       }, "length_mm": 58,  "weight_g": 14,    "icon": "lime.png" },
  { "week": 16, "name": { "en-GB": "Avocado",    "en-US": "Avocado"    }, "length_mm": 120, "weight_g": 100,   "icon": "avocado.png" },
  { "week": 20, "name": { "en-GB": "Banana",     "en-US": "Banana"     }, "length_mm": 160, "weight_g": 300,   "icon": "banana.png" },
  { "week": 24, "name": { "en-GB": "Sweetcorn",  "en-US": "Corn on the cob" }, "length_mm": 210, "weight_g": 600, "icon": "sweetcorn.png" },
  { "week": 28, "name": { "en-GB": "Aubergine",  "en-US": "Eggplant"   }, "length_mm": 260, "weight_g": 1000,  "icon": "aubergine.png" },
  { "week": 32, "name": { "en-GB": "Butternut squash", "en-US": "Butternut squash" }, "length_mm": 300, "weight_g": 1700, "icon": "butternut.png" },
  { "week": 36, "name": { "en-GB": "Cantaloupe", "en-US": "Cantaloupe" }, "length_mm": 330, "weight_g": 2800,  "icon": "cantaloupe.png" },
  { "week": 40, "name": { "en-GB": "Watermelon", "en-US": "Watermelon" }, "length_mm": 360, "weight_g": 3400,  "icon": "watermelon.png" }
]
```

* Provide explicit values for every week **0–40** (no interpolation). Week 0-3 share the earliest icon.
* Localise `name` per `locale`; convert units at render time.

## Rendering & Layout (v2)

* Provide **`full.liquid`**, **`half_horizontal.liquid`**, **`half_vertical.liquid`**, **`quadrant.liquid`** files as required by TRMNL; reuse a compact layout for smaller canvases. ([docs.usetrmnl.com][6])
* Use v2 utilities/components and follow the Troubleshooting Guide to satisfy stricter markup rules. ([usetrmnl.com][1])
* Typography: large “Week N”, centred 1-bit icon, label, and small caption `~length · ~weight`.

## Logic (client-side, no server)

1. Resolve **due date**:

   * `due_date` → parse as local date.
   * else `due_month` + `month_anchor_day` → local date.
2. Compute **gestational week**: `week = clamp( floor( (280 − days_to_due) / 7 ), 0, 40 )`.
3. Select comparator: exact match for `week`; else nearest lower week.
4. Unit conversion:

   * Metric: show `mm` and `g`.
   * Imperial: show inches (1 decimal) and ounces (or lb/oz when appropriate).
5. Localisation:

   * Choose `name[locale]`.
   * Minor copy differences (`Week` vs `Week`, US spelling only needed for produce names like aubergine/eggplant).
6. Timezone:

   * Use TRMNL-provided UTC offset or IANA where available to define “today”. ([help.usetrmnl.com][5])

## Assets (icons)

* **PNG** format (1-bit or dithered), bold silhouettes suited to e-ink.
* **38 icons total** covering weeks 0-40 (one for weeks 0-3, plus one each for weeks 4-40). See `weeks.md` for the complete list.
* Icons are **hosted on GitHub** and loaded via `raw.githubusercontent.com` URLs using `icon_base_url`.
* Designed as monochrome/1-bit style, simple silhouettes optimized for e-ink displays.
* **External calls are limited to icons** hosted on GitHub.

### Icon hosting setup

* Store PNG files in `images/` in this repo.
* Make the repository public so `raw.githubusercontent.com` can serve the images.
* Set the `icon_base_url` variable in each Liquid template:
  ```liquid
  {% assign icon_base_url = "https://raw.githubusercontent.com/USERNAME/bump-compare-trmnl/main/images" %}
  ```
* Build icon URLs in JS with `iconEl.src = '{{ icon_base_url }}/' + comparator.icon;`.

## TRMNL features we’ll use

* **Private Plugin** with WYSIWYG/markup editor for rapid iteration. ([help.usetrmnl.com][9])
* **Custom fields** for settings UI. ([help.usetrmnl.com][4])
* **Advanced Liquid / JS logs** during development (timezone helpers, debugging). ([help.usetrmnl.com][5])
* **Import/Export** for sharing the plugin bundle. ([help.usetrmnl.com][10])

## Deliverables

1. **Private Plugin** (v2-compliant) ready to install:

   * Completed **markup files** (full.liquid, half_horizontal.liquid, half_vertical.liquid, quadrant.liquid).
   * Embedded **weeks data** (weeks 0–40).
   * **Custom fields** schema (`custom_fields.yml`).
   * **PNG icon pack** (hosted in `images/`).
2. **README** for authors:

   * How to set due date/month, locale, and units.
   * How interpolation works and how to add/replace icons.

## Acceptance Criteria

* Works on TRMNL hardware and web preview using **Framework v2**.
* External network calls are limited to GitHub-hosted icon PNGs.
* Correct week calculation across DST/offsets using TRMNL-provided timezone variables.
* Localisation switch changes names and units appropriately.
* All images display crisply in 1-bit at all TRMNL render sizes.

---

### References

* TRMNL Framework v2 guides (overview, upgrade, troubleshooting). ([usetrmnl.com][1])
* TRMNL docs (overview, templating, plugin creation, installation/management flows). ([docs.usetrmnl.com][6])
* Private Plugins editor, custom fields, debugging, import/export. ([help.usetrmnl.com][9])
* Advanced Liquid date/time & timezone variables. ([help.usetrmnl.com][5])
* Cloudflare Workers free-tier limits (requests, CPU), pricing. ([Cloudflare Docs][7])

[1]: https://usetrmnl.com/framework?utm_source=chatgpt.com "Design System"
[2]: https://help.usetrmnl.com/en/collections/7820559-plugins?utm_source=chatgpt.com "Plugins | TRMNL Help Center"
[3]: https://usetrmnl.com/developers?utm_source=chatgpt.com "Developers - build the future of e-ink"
[4]: https://help.usetrmnl.com/en/articles/10513740-custom-plugin-form-builder?utm_source=chatgpt.com "Custom plugin form builder"
[5]: https://help.usetrmnl.com/en/articles/10693981-advanced-liquid?utm_source=chatgpt.com "Advanced Liquid"
[6]: https://docs.usetrmnl.com/?utm_source=chatgpt.com "TRMNL API: Overview"
[7]: https://developers.cloudflare.com/workers/platform/limits/?utm_source=chatgpt.com "Limits · Cloudflare Workers docs"
[8]: https://docs.usetrmnl.com/go/plugin-marketplace/plugin-creation?utm_source=chatgpt.com "Plugin Creation"
[9]: https://help.usetrmnl.com/en/articles/9510536-private-plugins?utm_source=chatgpt.com "Private Plugins"
[10]: https://help.usetrmnl.com/en/articles/10542599-importing-and-exporting-private-plugins?utm_source=chatgpt.com "Importing and exporting private plugins"
