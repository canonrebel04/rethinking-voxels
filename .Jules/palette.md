## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2024-10-24 - Hidden Easter Egg Setting Exposed
**Learning:** High-value micro-UX improvements can be found by extracting translation keys from `.lang` files and cross-referencing them against mapped options in `shaders.properties`. In this case, `CONWAY` was fully translated and implemented in the `.glsl` source but completely hidden from users because it lacked an entry in `shaders.properties` screens.
**Action:** Replace an `<empty>` spacer in an appropriate screen mapping (like `screen.OTHER_SETTINGS`) with the newly exposed variable to make it user-configurable without breaking the UI grid layout.
