## 2024-05-19 - Exposing Orphaned Shader UI Options
**Learning:** In Minecraft shader packs, options defined in `.lang` files but omitted from `shaders.properties` become "orphaned" and inaccessible to users. Using `<empty>` spacers effectively can maintain grid column alignment while exposing these options logically.
**Action:** Always cross-reference `shaders.properties` with `.lang` localization entries to identify hidden settings. When adding them to `shaders.properties` screens, replace `<empty>` tokens instead of just appending them to preserve the intended layout structure.
