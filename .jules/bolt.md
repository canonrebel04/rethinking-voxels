## 2024-07-16 - GLSL pow2 Optimization
**Learning:** For GLSL performance optimization, when replacing `pow(x, 2)`, the `pow2(x)` function in `common.glsl` should be used if it's in scope. `common.glsl` implements this as an overloaded function, not a macro, making it safe and efficient.
**Action:** Replace `pow(..., 2)` with `pow2(...)` across GLSL files when `common.glsl` is included, specifically targeting `shaders/program/prepare7_fsh.glsl` and `shaders/program/shadowcomp_irradiancecache_*.glsl`.
