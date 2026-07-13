## 2024-07-13 - UI Option Grid Alignment
**Learning:** When adding missing options back into the UI in `shaders.properties`, they must be paired with `<empty>` placeholders or overwrite existing `<empty>` pairs to maintain the columnar (Left/Right) grid layout without shifting other settings.
**Action:** Always count the items in a `screen.[NAME]=` mapping and insert options in pairs (e.g., `OPTION_NAME <empty>`) if appending or inserting, or overwrite existing `<empty>` values, to preserve the UI layout.
