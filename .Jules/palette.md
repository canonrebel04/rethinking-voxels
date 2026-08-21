## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.

## 2024-05-18 - Exposing hidden sliders in UI
**Learning:** Variables listed in `sliders=` of `shaders.properties` but lacking a `screen.*=` assignment and `.lang` localization entries are hidden from the user and represent opportunities for UX improvements by exposing them in appropriate menu screens (replacing `<empty>` layout spacers).
**Action:** Audit shader configurations for such variables and expose them to users while adding corresponding localized names and `.comment` tooltips.
