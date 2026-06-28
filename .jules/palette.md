## 2024-06-28 - Discovering Hidden Features
**Learning:** Cross-referencing localization strings (`.lang`) with configuration properties (`shaders.properties`) is a vital UX audit step in this ecosystem to discover fully implemented features that are inaccessible to users because they were omitted from UI screens.
**Action:** Always start a UX audit in shaderpack repositories by checking for orphaned option keys in `.lang` files that have no matching representation in the `screen.*` menus.
