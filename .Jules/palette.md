## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-09-08 - Exposing Hidden Options via Spacers
**Learning:** Shaderpacks often contain options fully implemented in source code and translations, but hidden from the UI. Exposing these by trading `<empty>` spacers maintains grid stability while unlocking new UX options.
**Action:** Continue cross-referencing `.lang` files against `shaders.properties` to find and safely expose orphaned settings.
