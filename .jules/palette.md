## 2024-05-24 - Exposing Orphaned UI Options
**Learning:** Some localization options exist in .lang files but are missing from `shaders.properties` screens, making them inaccessible to users in the UI. Exposing them in the relevant menus improves accessibility to existing features.
**Action:** Identify missing options by diffing .lang variables and `shaders.properties` screens, then append them to logical menus (replacing `<empty>` spacers) to preserve grid layouts.
