## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.
## 2024-08-11 - Expose Missing Settings
**Learning:** Missing or inaccessible UI settings can be identified by cross-referencing `.lang` localization entries against the UI hierarchy in `shaders.properties`. Orphaned `.lang` strings often indicate a setting that needs to be added to the property tree (e.g., exposing a slider by adding a missing `screen` mapping) to be accessible to users.
**Action:** Programmatically parse and compare `.lang` and `shaders.properties` to find and expose missing settings in the UI.
