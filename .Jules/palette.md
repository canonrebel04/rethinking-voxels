## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-05-13 - Exposed End Game of Life (CONWAY)
**Learning:** Some shader options are fully implemented in code (like CONWAY) and localized in lang files, but accidentally left out of the main menu screens (like `screen.VX_WORLD` in `shaders.properties`). This orphans them, making fun easter egg UX configurations invisible.
**Action:** Always cross-reference `option.` translations in `.lang` files or macro definitions in `.glsl` files with `.properties` mapping to find low-hanging fruit for exposing hidden settings instead of creating new ones.
