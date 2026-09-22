## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2026-09-22 - Exposed Hidden Shader Options
**Learning:** Fully implemented and translated options can sometimes be orphaned from the settings menu (`shaders.properties`), rendering them inaccessible. Checking for translations missing from screen mappings reveals these micro-UX opportunities.
**Action:** Extract all base translation keys from `.lang` files and cross-reference them against screen layouts in `shaders.properties` to find hidden settings. Replace `<empty>` layout spacers to expose them.
