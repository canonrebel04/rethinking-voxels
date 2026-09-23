## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2024-09-23 - Expose orphaned localized settings
**Learning:** When settings are fully defined in GLSL (e.g. `#define CONWAY`) and localized in `.lang` files but omitted from `shaders.properties`, they are hidden from users. This is a clear micro-UX win to expose them in appropriate UI screens.
**Action:** Replaced an `<empty>` spacer in `screen.VX_WORLD` with `CONWAY` to expose it.
