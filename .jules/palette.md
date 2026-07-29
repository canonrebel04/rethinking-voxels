## 2024-07-29 - Grouping Orphaned Settings in Shader Config
**Learning:** In Minecraft shader config files (shaders.properties), related UI options (like a toggle and its slider) that are disconnected in the UI can be grouped into sub-menus to cleanly expose missing/orphaned settings.
**Action:** Always cross-reference .lang keys against the properties hierarchy to find orphaned settings, and group them logically within bracketed sub-menus rather than appending to root menus.
