# Bump Compare

## Summary

A single-purpose TRMNL v2 plugin that shows the current gestational week and a lo-fi 1-bit fruit/veg comparator. Users set an approximate due date. The plugin calculates the current week automatically and updates each refresh. Icons are hosted on GitHub.

## Objectives

* Zero-maintenance deployment (no server to run).
* Clean presentation on TRMNL’s e-ink displays using Framework v2 components.
* UK English + metric and US English + imperial selectable in settings.
* Account for every week (0–40) with a recognisable 1-bit icon and approximate length/weight.

## Scope & Constraints

* One visual style only: monochrome, 1-bit bitmaps (with optional dithering).
* One comparator set (produce). Keep naming UK-friendly; map US variants in localisation.
* No backend by default; logic runs in markup with GitHub-hosted icons.
* TRMNL v2 layout and markup requirements apply.

## Implementation Details

Technical specifics live in `AGENTS.md`, including:

* Custom field definitions and expected formats.
* Data model structure and week calculation logic.
* Icon hosting setup and filename conventions.
* Testing checklist and validation expectations.

## Supporting Docs

* `PLUGIN_SETUP.md`
* `CUSTOM_FIELDS_SETUP.md`
* `weeks.md`
* `shared_markup.liquid`

## Licensing

This plugin's visual design, markup, and data-parsing logic are licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).

- License: `CC BY 4.0`
- Full text: <https://creativecommons.org/licenses/by/4.0/>
- Repository license file: `LICENSE`

## Support & Maintenance

End users can request support by opening an issue in this repository.

Maintenance policy:
- Best effort maintenance for active use, including refresh intervals as low as 5 minutes.
- If functionality regresses, fixes will be prioritized based on severity and reproducibility.

## Asset Provenance

All plugin icons in `images/` and `images_clean/` are original assets created by the repository maintainer using ChatGPT image generation workflows.
No third-party stock/icon packs are included in this repository.
