## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.

## 2026-09-17 - Exposing Orphaned Settings
**Learning:** In shaderpack configurations (like shaders.properties), it's common to find features that are fully implemented in code (.glsl) and translated (.lang) but are completely missing from the UI because they lack an assignment in a screen mapping. These represent high-value micro-UX improvements.
**Action:** Extract all base translation keys from .lang files and cross-reference them against screen mappings to identify and expose functional, hidden settings by replacing <empty> layout spacers.
