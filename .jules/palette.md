## 2024-07-04 - Expose Missing World Outline Settings
**Learning:** Found that some shader settings (like `option.WORLD_OUTLINE_THICKNESS`) existed in language files but were disconnected from the `shaders.properties` configuration UI, preventing users from accessing them or displaying them nicely. The missing settings resulted in hidden functionality.
**Action:** Always cross-reference the `.lang` file definitions against the `shaders.properties` structure. Creating a dedicated sub-menu using `[MENU_NAME]` keeps the UI clean while exposing newly connected settings.
