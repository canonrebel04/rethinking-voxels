## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-10-01 - Hidden Settings Exposed
**Learning:** Found options that have .glsl implementations and .lang translations but were missing from shaders.properties UI screens, acting as orphaned features.
**Action:** Replaced <empty> layout spacers in appropriate screen menus with the missing option names (e.g., CONWAY in screen.VX_WORLD) to expose them to users.
