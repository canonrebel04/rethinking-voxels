## 2024-05-24 - Cross-referencing UI Strings to Expose Hidden Settings
**Learning:** In Minecraft shader packs without standard UI frameworks, localized strings in `.lang` files that aren't mapped in `shaders.properties` effectively hide functionality from users. Orphaned language keys signify inaccessible settings.
**Action:** When auditing shader configuration interfaces, programmatically cross-reference `.lang` options against `shaders.properties` screen mappings to find and expose stranded features to users while maintaining grid layout alignment.
