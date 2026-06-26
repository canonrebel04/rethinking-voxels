## 2024-05-18 - Avoid pow(x, 2.0) in GLSL
**Learning:** In GLSL, standard `pow(x, 2.0)` evaluates via slower `exp2(y * log2(x))` logic. Since the shader doesn't always guarantee `common.glsl` with `pow2(x)` is included (like in `irisRequired.glsl`), it's better to use direct inline multiplication `(x * x)` or explicitly `pow2(x)` with typecasting `pow2(float(x))` when available.
**Action:** Always favor inline multiplication `(x * x)` or optimized `pow2()` overrides for squares instead of using the built-in `pow(x, 2.0)` function.
