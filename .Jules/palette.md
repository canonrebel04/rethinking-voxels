## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2024-10-19 - Exposing hidden CONWAY option
**Learning:** Found an orphaned translation for `CONWAY` (End Game of Life) which is implemented in `shaders/lib/common.glsl` and translated in `.lang` files but completely missing from the `shaders.properties` UX layout. This is a common pattern in shaderpacks where interesting features get lost because they aren't wired up to the settings menu.
**Action:** When auditing shaderpacks for UX improvements, extract all translation keys and cross-reference them against properties layouts to find orphaned settings. These can easily be added by replacing `<empty>` spacers.
