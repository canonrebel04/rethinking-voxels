## 2026-07-20 - [Missing Configs in Menus]
**Learning:** Found multiple shader options defined in the codebase and `en_US.lang` that were completely omitted from the `shaders.properties` configuration screens, making them inaccessible to users in the Minecraft shader settings menu.
**Action:** Always cross-reference `.lang` files and shader source logic against `shaders.properties` screen layouts to ensure options are exposed. When appending options to menus, substitute `<empty>` placeholders to preserve UI column grid alignment.
