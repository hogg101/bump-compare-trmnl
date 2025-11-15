# Project Brief — “Bump Compare” (TRMNL v2 plugin)

## Summary

A single-purpose TRMNL v2 plugin that shows the current gestational week and a **lo-fi 1-bit** fruit/veg comparator. User sets an approximate due date (month or exact date). The plugin calculates the current week automatically and updates each refresh. No external hosting by default; all logic runs in the plugin’s markup (client-side). Optional fallback: Cloudflare Worker if we later decide to centralise data or A/B assets.

## Objectives

* Zero-maintenance deployment (no server to run).
* Clean presentation on TRMNL’s e-ink displays using **Framework v2** components/utilities. ([usetrmnl.com][1])
* UK English + metric and US English + imperial selectable in settings.
* Account for **every week** (0–40, clamped) with a recognisable 1-bit icon and approximate length/weight.
* Friendly upgrade path to a lightweight Worker if needed.

## Scope & Constraints

* **One visual style only**: monochrome, 1-bit bitmaps (with optional dithering). ([help.usetrmnl.com][2])
* **One comparator set** (produce). Keep naming UK-friendly; map US variants in localisation.
* **No backend by default**: use TRMNL Private Plugin markup, custom fields, Liquid, and client-side JS. ([usetrmnl.com][3])
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
  { "week": 4,  "name": { "en-GB": "Poppy seed", "en-US": "Poppy seed" }, "length_mm": 1,   "weight_g": 0.002, "icon": "poppy.svg" },
  { "week": 8,  "name": { "en-GB": "Raspberry",  "en-US": "Raspberry"  }, "length_mm": 16,  "weight_g": 1,     "icon": "raspberry.svg" },
  { "week": 12, "name": { "en-GB": "Lime",       "en-US": "Lime"       }, "length_mm": 58,  "weight_g": 14,    "icon": "lime.svg" },
  { "week": 16, "name": { "en-GB": "Avocado",    "en-US": "Avocado"    }, "length_mm": 120, "weight_g": 100,   "icon": "avocado.svg" },
  { "week": 20, "name": { "en-GB": "Banana",     "en-US": "Banana"     }, "length_mm": 160, "weight_g": 300,   "icon": "banana.svg" },
  { "week": 24, "name": { "en-GB": "Sweetcorn",  "en-US": "Corn on the cob" }, "length_mm": 210, "weight_g": 600, "icon": "sweetcorn.svg" },
  { "week": 28, "name": { "en-GB": "Aubergine",  "en-US": "Eggplant"   }, "length_mm": 260, "weight_g": 1000,  "icon": "aubergine.svg" },
  { "week": 32, "name": { "en-GB": "Butternut squash", "en-US": "Butternut squash" }, "length_mm": 300, "weight_g": 1700, "icon": "butternut.svg" },
  { "week": 36, "name": { "en-GB": "Cantaloupe", "en-US": "Cantaloupe" }, "length_mm": 330, "weight_g": 2800,  "icon": "cantaloupe.svg" },
  { "week": 40, "name": { "en-GB": "Watermelon", "en-US": "Watermelon" }, "length_mm": 360, "weight_g": 3400,  "icon": "watermelon.svg" }
]
```

* Populate weeks **0–40** fully with 20 anchor weeks. Interpolate values between anchor weeks. Weeks 0-3 use the earliest anchor icon.
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

* **SVG** format, bold silhouettes suited to e-ink.
* **20 icons total** covering weeks 0-40 (see `ICONS.md` for complete list).
* Icons are **embedded directly inline in the Liquid markup** - no hosting, no URLs, no external files.
* The SVG markup (`<svg>...</svg>`) is pasted directly into the template files.
* Designed as monochrome/1-bit style, simple vector shapes optimized for e-ink displays.
* **Completely self-contained** - no external dependencies or network calls.

## Optional backend (later, only if needed)

If we decide to host data/assets centrally (e.g., dynamic copy, analytics), serve **markup JSON** from a **Cloudflare Worker**:

* Free plan: up to **100k requests/day**; CPU time per invocation is modest on free tier. ([Cloudflare Docs][7])
* Keep the Worker stateless; ship icons via CDN or Pages Assets.
* TRMNL “Plugin Markup URL” points to the Worker endpoint that returns `markup` strings. ([docs.usetrmnl.com][8])

## TRMNL features we’ll use

* **Private Plugin** with WYSIWYG/markup editor for rapid iteration. ([help.usetrmnl.com][9])
* **Custom fields** for settings UI. ([help.usetrmnl.com][4])
* **Advanced Liquid / JS logs** during development (timezone helpers, debugging). ([help.usetrmnl.com][5])
* **Import/Export** for sharing the plugin bundle. ([help.usetrmnl.com][10])

## Deliverables

1. **Private Plugin** (v2-compliant) ready to install:

   * Completed **markup files** (full.liquid, half_horizontal.liquid, half_vertical.liquid, quadrant.liquid).
   * Embedded **weeks data** (weeks 0–40 with 20 anchor points).
   * **Custom fields** schema (`custom_fields.yml`).
   * **SVG icon pack** (20 icons, embedded in markup).
2. **README** for authors:

   * How to set due date/month, locale, and units.
   * How interpolation works and how to add/replace icons.
3. (Optional) **Cloudflare Worker** stub and deploy script (commented out by default).

## Acceptance Criteria

* Works on TRMNL hardware and web preview using **Framework v2**.
* No external network calls in the default build.
* Correct week calculation across DST/offsets using TRMNL-provided timezone variables.
* Full coverage of weeks 0–40 with 20 recognisable comparators.
* Localisation switch changes names and units appropriately.
* All images display crisply in 1-bit at all TRMNL render sizes.

## Milestones

* **M1 — Prototype (markup-only)**: ✅ Complete - week calc, locale/units toggle, v2 layout, all viewport sizes.
* **M2 — Full Data & Icons**: populate weeks 4–40, interpolate sizes, complete icon set.
* **M3 — Polish**: typography tweaks for half/quadrant, error states (missing date), exportable ZIP.
* **M4 — (Optional) Worker**: add Worker endpoint, move data/icons to CDN, flip plugin to remote markup.

## Risks & Notes

* **Naming consistency** (aubergine/eggplant, sweetcorn/corn): covered via localisation.
* **Icon legibility**: enforce bold silhouettes; test on real device.
* **Framework v2 rules**: validate with the v2 Troubleshooting guide before shipping. ([usetrmnl.com][1])

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
