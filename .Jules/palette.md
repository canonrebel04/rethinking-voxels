## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-10-14 - Unexposed UX Setting CONWAY
**Learning:** Hidden micro-UX features, like the "CONWAY" shader option that enables Conway's Game of Life in the End dimension, might have full `.lang` definitions and be coded in `.glsl`, but be missing from the UI grid in `shaders.properties`. Replacing `<empty>` spacers with these settings exposes cool functionality without breaking the UI grid layout.
**Action:** Audit `shaders.properties` against `.lang` files to identify fully localized but unmapped variables, and substitute them for `<empty>` slots in logically relevant menus like `OTHER_SETTINGS`.
