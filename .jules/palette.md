## 2024-06-20 - Exposing Hidden Options in UI
**Learning:** Some features defined in `shaders/shaders.properties` are missing their localization keys (`option.*` and `option.*.comment`) in `shaders/lang/en_US.lang`. When this happens, the UI displays raw variable names (like `VOLUMETRIC_BLOCKLIGHT`) and lacks tooltips, severely degrading UX and accessibility.
**Action:** Always check if all options exposed in `shaders.properties` UI screens have corresponding localization entries in `.lang` files to ensure they are presented to users cleanly.
