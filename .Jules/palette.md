## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-10-07 - Hidden Shader Options
**Learning:** Some shader options like `CONWAY` have translations and underlying shader implementations but are orphaned from the configuration menus, hidden behind `<empty>` placeholders in `shaders.properties`. This creates a poor UX where users cannot discover or toggle these features without manually editing configuration files.
**Action:** Audit `shaders.properties` against `.lang` files and `.glsl` implementations to find options that are fully featured but hidden. Expose them by replacing `<empty>` placeholders in appropriate menu screens.
