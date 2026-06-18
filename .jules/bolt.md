## 2024-05-24 - GLSL Performance Optimization
**Learning:** Found that `pow(x, 2.0)` or `pow(x, 2)` can be slow in GLSL, evaluating via `exp2(y * log2(x))`. The `pow2(x)` function in `shaders/lib/common.glsl` (if available) or `(x * x)` inline is significantly faster.
**Action:** Replace instances of `pow(..., 2.0)` and `pow(..., 2)` with inline multiplication `(...) * (...)` or `pow2(...)` where applicable for performance improvements.
