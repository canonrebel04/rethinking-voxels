## 2024-06-05 - Missing UI text configurations
**Learning:** Found several variables (e.g. `BLOCKLIGHT_STRENGTH`, `TRANSLUCENT_LIGHT_TINT`) defined in properties files that didn't have user-friendly UI text or tooltips configured in `en_US.lang`. When missing, these fallback to raw technical variable names in the settings menu, which degrades UX.
**Action:** Added user-friendly names and helpful tooltips to `.lang` file so the settings menus display properly for users exploring the shader options.
