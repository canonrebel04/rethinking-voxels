## 2024-05-15 - Exposing Orphaned UI Settings
**Learning:** In this shaderpack, missing UI settings can be found by cross-referencing `.lang` localization entries with `shaders.properties` UI mappings. Orphaned `.lang` strings mean a setting is configured but missing from the UI.
**Action:** Next time, I will programmatically compare `.lang` keys against `shaders.properties` mapping values to identify hidden settings and add them to the properties tree by replacing `<empty>` layout tokens to maintain grid alignment.
