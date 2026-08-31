## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.

## 2024-05-18 - Missing UI configurations
**Learning:** When developing shader packs for Minecraft with OptiFine/Iris, if options are missing from the configuration file (`shaders.properties`) inside `screen.*=` assignments, they will not be exposed to the user interface menu, even if they're implemented in code or have valid entries in `.lang` files and are defined as sliders. Unexposed options can be easily fixed by finding their logical section and substituting them for `<empty>` spacer tags.
**Action:** Expose stranded options and sliders in logical UI sections (e.g. `BLOCKLIGHT_STRENGTH` in `screen.ADV_LIGHTPROP_STUFF`), ensuring to define missing descriptions inside `.lang` files.
