## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2024-09-07 - Unlocalized Shader Options
**Learning:** In Minecraft shader packs, exposing a setting in `shaders.properties` (like `CONWAY`) without ensuring it has matching `.lang` strings will cause the raw translation key (`option.CONWAY`) to display, resulting in a broken and confusing UX.
**Action:** Always strictly verify that corresponding localization strings exist in the `.lang` files before adding options to the UI configuration menus.
