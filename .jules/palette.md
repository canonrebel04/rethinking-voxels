## 2024-05-18 - Missing Lang Entries for Options
**Learning:** Several options referenced in `shaders.properties` screens (e.g., `VOLUMETRIC_BLOCKLIGHT`, `DENOISING`, `TRANSLUCENT_LIGHT_CONDUCTION`) did not have corresponding `option.[NAME]` and `option.[NAME].comment` entries in `shaders/lang/en_US.lang`. This results in missing names and tooltips in the shader options menu.
**Action:** Add missing `option.` and `option.comment` keys to the lang file for these unmapped properties.
