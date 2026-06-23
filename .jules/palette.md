## 2024-06-24 - Orphaned Settings in shaders.properties
**Learning:** Certain shader configuration options mapped in the UI localization `.lang` file were not accessible via the options screens defined in `shaders.properties` due to missing screen mappings, making the UI confusing and incomplete for users.
**Action:** Always cross-reference options defined in `.lang` with `shaders.properties` and add missing ones to corresponding existing screens by replacing `<empty>` placeholder spacers, which cleanly exposes the settings without breaking the intended UI grid layout.
