## 2024-05-18 - Orphaned Lang Options
**Learning:** Missing or inaccessible UI settings in this shaderpack can be identified by cross-referencing `.lang` localization entries against the UI hierarchy in `shaders.properties`. Orphaned `.lang` strings often indicate a setting that needs to be added to the property tree to be accessible to users.
**Action:** Programmatically identify missing UI settings by cross-referencing `.lang` and `shaders.properties` and add them to the property tree in `shaders.properties`.
