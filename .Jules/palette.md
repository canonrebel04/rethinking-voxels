## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-05-24 - Exposing Orphaned UI Options
**Learning:** In Minecraft shader packs, slider configurations in shaders.properties without explicit screen mapping assignments remain functional but are hidden from the user, leading to a suboptimal UX where intended customization isn't accessible.
**Action:** Audit and identify missing UI settings by cross-referencing slider lists with screen maps, exposing them in logical sub-menus and adding necessary .lang tooltips.
