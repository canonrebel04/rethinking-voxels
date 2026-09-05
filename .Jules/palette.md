## 2024-05-24 - Auditing Hidden Shader Variables
**Learning:** Important shader options like VBL_STRENGTH can be fully implemented and listed in lang files but hidden from the user interface if omitted from screen mapping arrays in shaders.properties. Replacing <empty> placeholders with these variables cleanly exposes them without breaking layout.
**Action:** Always cross-reference sliders defined in shaders.properties with screen mappings to identify and expose hidden options for a better user experience.
