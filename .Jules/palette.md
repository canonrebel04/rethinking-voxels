## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2026-09-30 - Expose hidden Conway's Game of Life option
**Learning:** High-value, fully implemented Easter egg/UX features can sometimes be hidden simply because they are missing from the screen layout mapping in shaders.properties. Extracting unused translation keys is a great way to discover them.
**Action:** When auditing shaderpacks for UX improvements, extract translation keys from .lang files and cross-reference them against screen layouts to find hidden settings.
