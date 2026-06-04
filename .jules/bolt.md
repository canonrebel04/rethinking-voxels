## 2024-05-18 - Replacing `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)`
**Learning:** For GLSL performance optimization, the codebase defines a faster `pow2(x)` function in `shaders/lib/common.glsl` that should be preferred over `pow(x, 2)` or `pow(x, 2.0)` for squaring variables.
**Action:** Replace all instances of `pow(..., 2)` and `pow(..., 2.0)` with `pow2(...)` where applicable.
