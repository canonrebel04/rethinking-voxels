## 2026-07-01 - Discovering Missing UI Settings
**Learning:** Missing or inaccessible UI settings in this shaderpack design system can be discovered by cross-referencing orphaned `.lang` localization strings against the property tree in `shaders.properties`.
**Action:** When evaluating UI completion, systematically extract all `option.[NAME]` keys from language files and `comm` them against `screen` assignments in properties to find hidden accessibility gaps.
