## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2026-09-11 - Exposing orphaned shader options
**Learning:** Missing UI settings in shaders without '.comment' descriptions can be safely exposed into existing appropriate sub-menus instead of top-level categories.
**Action:** Add orphaned options to logical existing screens in shaders.properties.
