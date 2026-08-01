## 2024-05-24 - Grouping related shader options into sub-menus
**Learning:** Orphaned settings with `.lang` entries but missing `shaders.properties` mappings are inaccessible to users. Grouping them with their base toggle under a new sub-menu (e.g., `[WORLD_OUTLINE_SETTINGS]`) not only exposes the missing setting but also cleans up the parent menu, preventing clutter.
**Action:** When finding a missing related setting (like a thickness slider for an effect), create a sub-menu to group the toggle and the slider together instead of just appending the slider to a busy top-level menu.
