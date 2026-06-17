## 2024-06-17 - Missing UI Options
**Learning:** Orphaned `.lang` strings for `screen.*` and `option.*` without corresponding references in `shaders.properties` mean those screens/options are inaccessible to users. Setting up the nested screen hierarchy in `shaders.properties` accurately is crucial for exposing UX settings.
**Action:** When working on shaderpacks, map `.lang` files against `shaders.properties` to find and fix hidden UI screens or options.
