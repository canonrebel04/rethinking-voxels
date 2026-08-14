## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.
## 2026-08-14 - Cross-referencing settings to expose hidden UI options
**Learning:** In this UI system, missing or inaccessible settings can be identified by finding options listed in `sliders=` that lack a `screen.*=` mapping. Exposing them requires cleanly overwriting `<empty>` placeholders to maintain columnar grid layouts without breaking the menus.
**Action:** Always programmatically parse and compare `sliders=` and `screen.*=` lines to ensure all valid configurations are presented to the user, and use existing `<empty>` spacers when adding them to the screens.
