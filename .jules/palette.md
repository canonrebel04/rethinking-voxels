## 2024-05-24 - Missing UI Properties lead to Variable Name Leaks
**Learning:** In Minecraft shader properties systems, missing a `.comment` or explicit translation key for a variable in `.lang` files causes the UI to fallback to raw variable names (e.g. `OCCLUSION_CASCADE_COUNT` instead of "Occlusion Cascade Count") and provide no descriptive tooltip to users, severely breaking UX conventions.
**Action:** Always cross-reference `shaders.properties` configuration with `shaders/lang/` localization files. Added automated script steps to detect and extract UI labels for orphaned configuration properties to improve interface descriptions.

## 2026-07-01 - Discovering Missing UI Settings
**Learning:** Missing or inaccessible UI settings in this shaderpack design system can be discovered by cross-referencing orphaned `.lang` localization strings against the property tree in `shaders.properties`.
**Action:** When evaluating UI completion, systematically extract all `option.[NAME]` keys from language files and `comm` them against `screen` assignments in properties to find hidden accessibility gaps.