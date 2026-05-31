
## 2024-05-24 - Shader Options Missing Tooltips
**Learning:** Found that when new shader options and sliders are added to `shaders.properties` or `lib/common.glsl`, they are often forgotten in the `lang` files. This results in raw variable names and no tooltips being displayed to the user in the UI. A seamless configuration experience requires all variables to have localized, user-friendly labels and descriptions.
**Action:** Always ensure that when configuration keys are introduced, proper UI text and tooltips are added simultaneously in `shaders/lang/en_US.lang`.
