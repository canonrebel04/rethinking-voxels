## 2024-06-25 - Missing Setting Pattern
**Learning:** In this codebase, settings documented in `.lang` files remain inaccessible in the UI unless explicitly mapped to a menu screen within `shaders.properties`. This creates orphaned settings that the user cannot interact with.
**Action:** When auditing the settings UI for missing options, systematically cross-reference `.lang` options with `shaders.properties` `screen.*` hierarchy, and add them by replacing `<empty>` layout spacers to preserve intended grid structures.
