## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Some functional `.glsl` options (like `CONWAY`) have translations in `.lang` but are hidden behind `<empty>` spacers in `shaders.properties`, confusing users who expect to toggle them in-game.
**Action:** When adding small touches of delight, check for these hidden, fully-implemented macros and replace `<empty>` UI slots to expose them.
