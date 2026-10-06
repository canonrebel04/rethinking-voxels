## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2026-10-06 - Hidden Shader Options
**Learning:** Some functional shader options (like CONWAY) are fully implemented and localized but hidden from the UI because they are missing from `shaders.properties`.
**Action:** Always cross-reference `.lang` files with `shaders.properties` to find hidden features that can be exposed by replacing `<empty>` spacers.
