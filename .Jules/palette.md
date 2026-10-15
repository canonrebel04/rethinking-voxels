## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-10-15 - Uncovering Hidden Configuration Variables
**Learning:** Checking for variables defined in `.lang` files but missing from `shaders.properties` can reveal valuable micro-UX improvements by exposing hidden features via replacing `<empty>` layout spacers.
**Action:** Extract translation keys from `.lang` files and cross-reference them against variables mapped in `shaders.properties` to find hidden settings.
