## 2024-05-15 - Missing shadow configurations in UI
**Learning:** Found several shadow-related configurations (SHADOW_QUALITY, shadowDistance) and other settings (DIRECTIONAL_BLOCKLIGHT, ENTITY_GN_AND_CT) that are orphaned: they have translations in en_US.lang but are missing from shaders.properties `screen` mappings. They are thus completely inaccessible in the UI.
**Action:** Add these missing options to the appropriate screens in shaders.properties to improve configuration accessibility.
