# Bump Compare

## Summary

A single-purpose TRMNL v2 plugin that shows the current gestational week and a lo-fi 1-bit fruit/veg comparator. Users set an approximate due date. The plugin calculates the current week automatically and updates each refresh. Icons are hosted on GitHub.

## Objectives

* Zero-maintenance deployment (no server to run).
* Clean presentation on TRMNL’s e-ink displays using TRMNL Framework components.
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

## Local Preview

This repo includes a project-local TRMNLP setup. It keeps Ruby and gems under `.trmnl-dev/`, with `src/` symlinks pointing back to the root templates so Chef copy/paste files remain the source of truth.

```sh
scripts/install_trmnlp.sh
./bin/trmnlp lint
./bin/trmnlp build
./bin/trmnlp serve
```

Preview runs at <http://127.0.0.1:4567>. To uninstall the local runtime and build output:

```sh
scripts/uninstall_trmnlp.sh
```

## Icon Regeneration

This repo supports two regeneration paths.

For Codex built-in image generation, generate each icon as an individual image on a flat `#ff00ff` chroma-key background. Process each generated file directly into a transparent grayscale PNG:

```sh
scripts/process_builtin_icon.sh /path/to/generated-icon.png aubergine.png
cp output/imagegen/bump-icons-individual/transparent/*.png images_clean/
```

Generated candidates are written to `output/imagegen/bump-icons-individual/` for review. Prefer individual runs over sprite sheets so every icon gets subject-specific prompting and no grid-cropping step is required.

For API-based parallel generation, set `OPENAI_API_KEY` locally and run:

```sh
scripts/generate_icons_batch.sh
```

Generated candidates are written to `output/imagegen/bump-icons/` for review. Use `DRY_RUN=1 scripts/generate_icons_batch.sh` to inspect the batch requests without making API calls.

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

## Chef Publishing Notes

These checks were required to pass TRMNL Chef validation for marketplace publishing:

- `author_bio` must exist in `custom_fields.yml` with at least `keyname`, `field_type`, and `name`.
- `author_bio.category` must use approved TRMNL category values. This plugin uses `life,personal`.
- Keep a valid static `<img src>` in markup. Avoid empty `src=""` placeholders.
- Avoid inline style usage (`style="..."`) and JS style mutation (`element.style.*`).
- Keep layout CSS in the shared stylesheet in `shared_markup.liquid`; viewport files should only set shell/viewport modifiers and render shared markup.
- Use TRMNL native-compatible patterns where possible (for example `<progress>` + `.value` in JS for progress updates).
