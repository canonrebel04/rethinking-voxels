## 2024-07-02 - Exposing missing UI settings
**Learning:** Some shader settings defined in `.lang` files and `common.glsl` are completely inaccessible to users because they were omitted from the property tree in `shaders.properties`.
**Action:** Always cross-reference `.lang` options against `shaders.properties` to find hidden/orphaned settings, and expose them by overwriting `<empty>` placeholders in the relevant screen mappings without breaking the columnar layout.
