# Asset Strategy for Bump Compare Plugin

## Current Situation

TRMNL doesn't provide built-in asset storage for private plugins. 

## ✅ Selected Strategy: GitHub-Hosted SVG Icons

**How it works:**
- Create icons as SVG (Scalable Vector Graphics) files
- **Host SVG files in a public GitHub repository**
- Reference icons via `raw.githubusercontent.com` URLs
- Icons are loaded from GitHub's CDN when the plugin renders
- Each Liquid template includes a configurable base URL variable

**Pros:**
- ✅ Free hosting via GitHub
- ✅ Easy to update icons (just push to repo)
- ✅ Clean separation of assets from markup
- ✅ SVG is scalable and crisp at any size
- ✅ No duplication - icons stored once in repo
- ✅ Version control for icons
- ✅ Can be cached by browser/CDN

**Cons:**
- ⚠️ Requires external network calls (GitHub CDN)
- ⚠️ Requires public GitHub repository
- ⚠️ Icons won't load if GitHub is unavailable

**Implementation:**
1. Create icons as SVG files
2. Store SVG files in the `images/` directory of the GitHub repository
3. Make the repository public
4. Set the `icon_base_url` variable in each Liquid template:
   ```liquid
   {% assign icon_base_url = "https://raw.githubusercontent.com/USERNAME/bump-compare-trmnl/main/images" %}
   ```
5. Update icon references in weeks_data from `.png` to `.svg`
6. JavaScript constructs full URLs: `iconEl.src = '{{ icon_base_url }}/' + comparator.icon;`

**Example:**
```liquid
{% assign icon_base_url = "https://raw.githubusercontent.com/USERNAME/bump-compare-trmnl/main/images" %}
...
iconEl.src = '{{ icon_base_url }}/' + comparator.icon;
```

**URL Format:**
- Base URL: `https://raw.githubusercontent.com/USERNAME/REPO-NAME/BRANCH/images`
- Full icon URL: `https://raw.githubusercontent.com/USERNAME/bump-compare-trmnl/main/images/poppy.svg`

---

## Alternative Options (Not Used - For Reference Only)

The following options are documented for reference but are **NOT being used** for this plugin:

## Option 1: SVG Embedded in Markup (Previous Strategy)

**How it works:**
- Embed SVG markup directly inline in the Liquid template files
- Icons are part of the markup itself - no separate files, no hosting, no external URLs

**Pros:**
- ✅ No external network calls
- ✅ Works offline
- ✅ No hosting required

**Cons:**
- ⚠️ Increases markup file size significantly
- ⚠️ Icons are duplicated in each viewport file
- ⚠️ Harder to update icons (requires editing markup)

## Option 2: Cloudflare Pages (Free CDN)

**How it works:**
- Host icons on Cloudflare Pages (free)
- Reference icons via URLs like `https://bump-compare-icons.pages.dev/poppy.svg`

**Pros:**
- ✅ Clean URLs
- ✅ Fast CDN
- ✅ Free hosting
- ✅ Easy to update icons

**Cons:**
- ⚠️ Requires external network calls (violates "no external calls" requirement)
- ⚠️ Requires setup

**Implementation:**
1. Create Cloudflare Pages site
2. Upload icons
3. Update markup to use CDN URLs
4. Icons accessible at: `https://your-site.pages.dev/icon-name.svg`

## Option 3: Cloudflare Worker + Pages Assets

**How it works:**
- Use Cloudflare Worker to serve markup
- Host icons on Cloudflare Pages Assets
- Worker returns markup with icon URLs

**Pros:**
- ✅ Centralized hosting
- ✅ Can add analytics/dynamic features later
- ✅ Free tier: 100k requests/day

**Cons:**
- ⚠️ More complex setup
- ⚠️ Requires backend (even if simple)
- ⚠️ External network calls

## Current Implementation

**We are using: GitHub-hosted SVG icons**

- ✅ **Free hosting** - icons hosted on GitHub's CDN via raw.githubusercontent.com
- ✅ **Easy updates** - just push new SVG files to the repository
- ✅ **Clean separation** - icons stored separately from markup
- ✅ **Version controlled** - icons tracked in git alongside code
- ✅ **Configurable** - base URL variable makes it easy to update if repo changes

## Next Steps

1. **Make the repository public** on GitHub
2. **Update the `icon_base_url` variable** in all Liquid templates with your GitHub username
3. **Ensure all SVG icon files** are in the `images/` directory
4. **Test** that icons load correctly from GitHub URLs

**To update the base URL:**
Replace `USERNAME` in the `icon_base_url` variable in each Liquid template file:
- `full.liquid`
- `half_horizontal.liquid`
- `half_vertical.liquid`
- `quadrant.liquid`

Example: If your GitHub username is `johndoe`, the URL would be:
```
https://raw.githubusercontent.com/johndoe/bump-compare-trmnl/main/images
```

