## 2024-06-22 - Orphaned Shader Options
**Learning:** Some shader options defined in `.lang` files are completely missing from the UI screens defined in `shaders.properties`. This makes the options unreachable by the user.
**Action:** When working on shaderpacks, use simple scripts to find orphaned `option.` variables in `.lang` files and add them to the appropriate `screen.` definitions in `shaders.properties` to ensure all functionality is accessible.
