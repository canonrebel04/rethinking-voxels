## 2026-08-03 - Grouping related UI Settings
**Learning:** In Minecraft shader packs, related UI settings like a toggle and its modifier (e.g., thickness) are sometimes left orphaned or separated, making the modifier inaccessible if the screen mapping is missing. Grouping a toggle and its associated sliders into a logical sub-menu cleans up top-level menus and exposes previously inaccessible settings while maintaining existing layout conventions.
**Action:** Create logical sub-menus (e.g., `[OPTION_SETTINGS]`) in `shaders.properties` to group top-level options with their respective orphaned modifier options, ensuring they are accessible to users without cluttering the main menus.

## 2024-05-18 - Missing UI Screen Accessibility
**Learning:** Orphaned UI screens (defined in `.lang` and mapping tree but not referenced in any parent screen) create completely inaccessible settings for users in shaderpack option menus.
**Action:** Always cross-reference `screen.NAME=` definitions with their usage inside other `screen=` mappings to find and restore missing settings menus.
## 2024-08-07 - Exposing orphaned UI settings
**Learning:** In Minecraft shaderpacks, UI settings can often be orphaned. The variables are defined and mapped with user-friendly names in `.lang` files, but missing from the actual `screen` layout property trees in `shaders.properties`, making them inaccessible to the end user. Cross-referencing missing `.lang` entries against `shaders.properties` is an effective micro-UX improvement to clean up menus and expose previously inaccessible settings.
**Action:** Use programmatic checks (e.g., cross-referencing lang option keys without `.comment` suffixes against property screens) to identify and restore these orphaned variables to the correct screen UI layouts, replacing `<empty>` placeholders where possible.
