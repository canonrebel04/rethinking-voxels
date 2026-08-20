## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.
## 2024-08-20 - Exposing Hidden Shader Configuration Options
**Learning:** Found several variables correctly defined as `#define` in GLSL (`BLOCKLIGHT_STRENGTH`, `TRANSLUCENT_LIGHT_TINT`) and registered as `sliders=` in `shaders.properties`, but missing from the UI screens (`screen.*=`) and localization files. They were effectively inaccessible hidden settings.
**Action:** Always cross-reference `sliders=` against `screen.*=` assignments to identify missing UI settings. Expose them by replacing `<empty>` layout spacers in relevant sub-menus (like `screen.BASIC_LIGHTPROP_STUFF`) and adding `.lang` entries to make them user-accessible.
