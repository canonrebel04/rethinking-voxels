## 2024-05-24 - GLSL pow(x, 2) Optimization
**Learning:** This codebase defines a `pow2()` function in `shaders/lib/common.glsl` specifically designed to replace `pow(x, 2.0)` calls, which are computationally more expensive because the standard `pow` function is generalized for arbitrary powers (usually compiled to `exp2(y * log2(x))`).
**Action:** Replace `pow(x, 2)` or `pow(x, 2.0)` with `pow2(x)` whenever `common.glsl` is included, to slightly improve performance by utilizing simple hardware multiplication `x * x`.
