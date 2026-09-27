## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-05-24 - Exposing Hidden Shader Options
**Learning:** Orphaned sliders in shaders.properties that lack screen layout mapping, despite being implemented in .glsl and translated in .lang, create invisible settings.
**Action:** Always cross-reference `sliders=` against `screen.*=` and replace `<empty>` layout placeholders to expose functional but hidden options to improve UX discoverability without adding new logic.
