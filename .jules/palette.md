## 2024-07-10 - Exposed Directional Blocklight Setting
**Learning:** Orphaned localization strings in Minecraft shaders often indicate an existing setting that was omitted from the properties menu. In this pack, 'DIRECTIONAL_BLOCKLIGHT' was fully defined in common.glsl and en_US.lang but completely inaccessible to users because it was missing from the screen mappings in shaders.properties.
**Action:** Always cross-reference the language file options against the screen configuration to identify hidden features, and add them back into logical sub-menus to improve discoverability.
