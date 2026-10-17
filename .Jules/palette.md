## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2024-05-18 - Missing Settings Exposed
**Learning:** Found that implemented shader options, such as CONWAY in common.glsl with translations, were not exposed in shaders.properties screen layouts, hiding them from users.
**Action:** Always check for translation keys that are missing from screen properties but exist in .glsl files to expose hidden options by replacing <empty> spacers in the settings menus.
