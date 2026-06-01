## 2026-06-01 - GLSL pow2 function
**Learning:** This codebase defines a faster `pow2(x)` function in `shaders/lib/common.glsl` that should be preferred over `pow(x, 2)` or `pow(x, 2.0)` for performance in GLSL since `pow()` is surprisingly expensive.
**Action:** Replace all instances of `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)`.
