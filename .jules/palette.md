## 2024-07-08 - Exposing Missing Shader Options
**Learning:** Some shader settings have localization entries in `.lang` files but are not actually mapped to any screen in `shaders.properties`, making them completely inaccessible in the user interface.
**Action:** Always cross-reference `.lang` options with the `screen.` layouts in `shaders.properties` to ensure all intended user settings are actually exposed in the UI. Replace `<empty>` placeholders when adding to menus to maintain grid layout alignment.
