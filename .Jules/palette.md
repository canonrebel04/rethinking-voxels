## 2024-09-07 - Missing UI Setting Exposed
**Learning:** Orphaned configuration sliders that are implemented in the code (e.g. `VBL_STRENGTH` in Minecraft shaders) but missing from UI screens or underlying `#define` assignments can cause confusion and leave accessible tuning options hidden from users.
**Action:** When auditing configurations like `shaders.properties`, use shell scripting to extract all sliders, cross-reference them against UI mappings (like `screen.VBL_SETTINGS=...`), and define corresponding backend `#define` logic if missing to correctly expose functional options.
## 2026-09-21 - Expose Conway's Game of Life option
**Learning:** Found a high-value micro-UX improvement: the 'CONWAY' setting is implemented in the shader source (`shaders/lib/common.glsl`) and has translation strings for both English and French (`shaders/lang/`), but it is missing from the configuration screens in `shaders/shaders.properties`. This means users cannot access this 'End Game of Life' visual effect.
**Action:** Add 'CONWAY' to a relevant configuration screen in `shaders.properties` (like replacing an `<empty>` spacer in `screen.VX_WORLD`) so users can actually toggle it.
