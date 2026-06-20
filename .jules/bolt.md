## 2024-05-24 - GLSL pow() function performance optimization
**Learning:** In GLSL, standard `pow(x, 2.0)` evaluates via slower `exp2(y * log2(x))`. It does not automatically optimize to `x * x`.
**Action:** Prefer the `pow2(x)` function defined in `shaders/lib/common.glsl` (which does `x * x`) over `pow(x, 2.0)`. If `common.glsl` is unavailable, use direct inline multiplication `(x * x)` instead.
