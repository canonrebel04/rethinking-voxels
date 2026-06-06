
## 2024-05-24 - Prefer pow2(x) over generic pow(x, 2.0) in GLSL
**Learning:** This codebase defines a faster custom `pow2(x)` function in `shaders/lib/common.glsl`. Using the generic `pow(x, 2.0)` or `pow(x, 2)` incurs unnecessary overhead in GLSL because `pow()` is generally implemented using `exp2(y * log2(x))` which is much slower than a simple multiplication `x * x`.
**Action:** Always prefer using `pow2(x)` over `pow(x, 2.0)` or `pow(x, 2)` throughout the codebase for squaring numbers to avoid performance bottlenecks.
