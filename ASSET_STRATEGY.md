# Asset Strategy for Bump Compare Plugin

## Current Situation

TRMNL doesn't provide built-in asset storage for private plugins. We have three options:

## Option 1: Base64 Embedded Images (Recommended for Zero-Maintenance)

**How it works:**
- Convert 1-bit PNG icons to base64 strings
- Embed them directly in the Liquid markup
- No external network calls needed

**Pros:**
- ✅ Zero maintenance - no server needed
- ✅ Works offline
- ✅ No external dependencies
- ✅ Matches README requirement: "No external network calls in the default build"
- ✅ 1-bit PNGs are small (~5-10KB each), so 10 icons = ~50-100KB total

**Cons:**
- ⚠️ Increases markup file size
- ⚠️ Icons are duplicated in each viewport file

**Implementation:**
1. Create icons as 1-bit PNGs
2. Convert to base64: `base64 -i icon.png -o icon.txt`
3. Store base64 strings in a data structure in the markup
4. Use `data:image/png;base64,{base64_string}` in img src

## Option 2: Cloudflare Pages (Free CDN)

**How it works:**
- Host icons on Cloudflare Pages (free)
- Reference icons via URLs like `https://bump-compare-icons.pages.dev/poppy.png`

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
4. Icons accessible at: `https://your-site.pages.dev/icon-name.png`

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

## Recommendation

**For M1-M3 (Current Phase): Use Option 1 (Base64)**

- Matches the "zero-maintenance" goal
- No external dependencies
- Simple to implement
- Icons are small enough that base64 is reasonable

**For M4 (Future): Consider Option 2 or 3**

- If you want to add analytics or A/B testing
- If you want to update icons without re-uploading plugin
- If you want to share icons across multiple plugins

## Next Steps

1. **Create icons** as 1-bit PNGs
2. **Convert to base64** and embed in markup
3. **Test** that icons display correctly
4. **Optionally** set up Cloudflare Pages later if needed

