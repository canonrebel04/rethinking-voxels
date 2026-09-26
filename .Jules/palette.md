## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2024-09-26 - Reveal Hidden Conway Option
**Learning:** In Minecraft shader packs, options mapped with translations and `#define`s can still be hidden from users if they lack a mapping in `shaders.properties` screen setups. Exposing these by replacing `<empty>` spacers provides instant micro-UX value without adding new logic.
**Action:** Audit `.lang` files against `shaders.properties` screen mappings to find and expose orphaned settings that are already implemented.
