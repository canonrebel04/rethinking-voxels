## 2024-11-04 - Exposing hidden options via sub-menus
**Learning:** Grouping a toggle and its associated sliders into a dedicated sub-menu within the properties file is an effective way to expose orphaned options and clean up the parent menu UI without cluttering it.
**Action:** Always check `.lang` files for related settings (like thickness, color) that are missing from `shaders.properties` and expose them via new `[SCREEN_NAME]` sub-menus.
