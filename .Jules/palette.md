## 2024-06-11 - Uncovering Hidden Settings through Localization Files
**Learning:** In this shaderpack codebase, missing UI screens can be identified by cross-referencing `.lang` localization entries against the UI hierarchy defined in `shaders.properties`. Orphaned `.lang` strings often indicate a setting slider that lacks a home screen, making it completely hidden or hard to access for users.
**Action:** Always diff `screen.*` strings between `.lang` files and `.properties` to systematically uncover and fix missing UI elements and menus.
