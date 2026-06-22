## 2024-05-18 - Avoid pow(x, 2) in GLSL
**Learning:** Found that `pow(x, 2)` or `pow(x, 2.0)` is used in various places. In GLSL `pow` evaluates as `exp2(y * log2(x))` which is slower than simple multiplication. Codebase has `pow2(x)` helper in `shaders/lib/common.glsl` for optimization which should be used instead. Mixing ints and floats inside `max()` can cause issues in older OpenGL versions/compilers, so using float literals like `0.0` is safer.
**Action:** Replace `pow(..., 2)` with `pow2(...)` and use explicit float literals in `max` comparisons where required for safety.
