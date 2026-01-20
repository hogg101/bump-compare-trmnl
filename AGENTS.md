# Repository Guidelines

## Project Structure & Module Organization
- Liquid templates live at the repo root: `full.liquid`, `half_horizontal.liquid`, `half_vertical.liquid`, `quadrant.liquid`. Each file includes its own HTML/CSS/JS.
- Configuration lives in `settings.yml` and `custom_fields.yml`.
- Icon assets belong in `images/` and are referenced by filename in the weeks data.
- Week-by-week comparator list and filenames live in `weeks.md`.

## Implementation Notes
- Custom fields: `due_month` (`YYYY-MM`), `due_date` (`YYYY-MM-DD`), `month_anchor_day` (default `15`), `locale` (`en-GB` | `en-US`), `units` (`metric` | `imperial`, auto from locale).
- Weeks data is embedded JSON inside each template. Provide explicit values for weeks 0–40; weeks 0–3 share the earliest icon. Localise `name` and convert units at render time.
- Week calculation: `week = clamp(floor((280 - days_to_due) / 7), 0, 40)`.
- Icon hosting uses GitHub raw URLs. Set `icon_base_url` per template, then build `iconEl.src` from the base + filename.
  ```liquid
  {% assign icon_base_url = "https://raw.githubusercontent.com/USERNAME/bump-compare-trmnl/main/images" %}
  ```

## Build, Test, and Development Commands
There is no automated build or test pipeline. Typical workflow:
- Edit a viewport file (e.g., `full.liquid`) and upload to TRMNL via the private plugin editor or ZIP import.
- Update `custom_fields.yml` and `settings.yml` in TRMNL when fields change.
- Verify output using TRMNL’s preview for full/half/quadrant layouts.

## Coding Style & Naming Conventions
- Indentation is 2 spaces in HTML/CSS/JS blocks inside Liquid templates.
- Keep Liquid variables in `snake_case` (e.g., `due_date_str`, `weeks_data`).
- Icon filenames should be lowercase with hyphens and `.png` extension (e.g., `poppy-seed.png`).
- Keep markup self-contained per template; avoid cross-file JS/CSS dependencies.

## Testing Guidelines
- No automated tests are set up.
- Manually verify: week calculation, locale/units switch, icon rendering, and layout on each viewport.
- Confirm external icon URLs resolve from `icon_base_url`.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative, sentence case (e.g., `Revamp templates and docs for PNG icon hosting`).
- Use a second paragraph for details when the change is large or multi-file.
- PRs should include a clear description, list of affected templates, and screenshots of TRMNL previews for all viewport sizes.
- Link related issues if they exist.

## Security & Configuration Notes
- Icons are served from GitHub raw URLs; keep the repository public if you want icons to load in TRMNL.
- Avoid embedding secrets in templates or config files.
