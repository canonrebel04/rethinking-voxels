## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-05-24 - Exposing Hidden Options
**Learning:** Options mapped in shaders.properties `sliders=` or with `.lang` translations/`.glsl` implementations can be hidden from the user if they lack a `screen.*=` assignment.
**Action:** Extract base translation keys and cross-reference them against mapped options to find micro-UX improvements by replacing `<empty>` layout spacers.
