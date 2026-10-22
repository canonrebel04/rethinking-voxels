## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-05-24 - Discovering Hidden UI Options via Translation Files
**Learning:** High-value micro-UX opportunities exist where features are fully implemented in the shader (e.g., `CONWAY` in `.glsl`) and fully translated in `.lang` files, but missing from the UI layout grid in `shaders.properties`.
**Action:** Always cross-reference base translation keys from `.lang` files (excluding `.comment`) against mapped options in `shaders.properties` to find invisible options. Expose them by replacing `<empty>` layout spacers.
