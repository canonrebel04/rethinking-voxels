## 2024-05-18 - Optimized GLSL pow2 function
**Learning:** Found that using standard `pow(x, 2)` or `pow(x, 2.0)` is less efficient in GLSL than custom built-in `pow2(x)` provided in `shaders/lib/common.glsl`.
**Action:** Replace all instances of `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)` throughout shader files to improve rendering performance. This falls directly under GLSL performance optimization.
