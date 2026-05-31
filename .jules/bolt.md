## 2024-05-24 - [GLSL pow() optimization]
**Learning:** For GLSL performance optimization, the codebase defines a faster `pow2(x)` function in `shaders/lib/common.glsl` that should be preferred over `pow(x, 2)` or `pow(x, 2.0)`.
**Action:** Replace `pow(expr, 2)` and `pow(expr, 2.0)` with `pow2(expr)` to improve performance.
