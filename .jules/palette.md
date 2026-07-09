## 2024-07-09 - Organized World Outline Settings
**Learning:** For Minecraft shader packs, exposing orphaned `.lang` strings (like WORLD_OUTLINE_THICKNESS) by moving related top-level toggles (WORLD_OUTLINE) into logical sub-menus ([WORLD_OUTLINE_SETTINGS]) in `shaders.properties` cleans up menus and restores access to previously inaccessible related settings.
**Action:** When adding missing options to `shaders.properties`, look for related toggles to group them into sub-menus to improve menu organization.
