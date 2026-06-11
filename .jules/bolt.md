## 2025-01-01 - GLSL pow() Performance Optimization
**Learning:** Found a codebase-specific performance pattern: the codebase defines a faster `pow2(x)` function in `shaders/lib/common.glsl`. This should be preferred over the standard `pow(x, 2.0)` or `pow(x, 2)` for squaring values, as `pow()` can be an expensive operation in shaders.
**Action:** Always check if squaring operations like `pow(..., 2.0)` can be replaced with `pow2(...)` when working in GLSL files in this codebase.
