## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2025-01-01 - Expose Missing Options by Replacing Layout Spacers
**Learning:** Orphaned configuration sliders implemented in shader code (like `ACCUM_FALLOFF_SPEED` and `BLOCKLIGHT_I`) but missing from UI layout maps (`screen.*=`) leave accessible options hidden from users. These can be elegantly exposed without disrupting UI formatting by replacing empty layout spacers (`<empty>`) in `shaders.properties`.
**Action:** When extracting all defined sliders and cross-referencing them against UI screen mappings, insert any missing but implemented variables into appropriate sub-menus by replacing `<empty>` placeholders. Always ensure corresponding translation keys (`option.OPTION_NAME`) are added to `.lang` files to prevent unlabelled UI components.
