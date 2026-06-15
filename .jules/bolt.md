## 2024-06-15 - GLSL pow() Performance
**Learning:** In GLSL, `pow(x, 2)` or `pow(x, 2.0)` is significantly slower than direct multiplication `x * x` or `pow2(x)` from common library functions, because standard `pow` evaluates using `exp2(y * log2(x))`. Codebase provides `pow2` in `/lib/common.glsl` which should be used.
**Action:** Replace `pow(..., 2)` with `pow2(...)` when `common.glsl` is available, or use direct inline multiplication if it's not.
