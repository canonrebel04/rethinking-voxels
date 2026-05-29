## 2024-05-19 - Fast powers of 2
**Learning:** Found multiple usages of `pow(..., 2)` in tight GLSL loops like irradiance cache gathering. Using `pow` is significantly slower than direct multiplication (`x*x`). A `pow2()` function already exists in `shaders/lib/common.glsl`.
**Action:** Replace `pow(..., 2)` and `pow(..., 2.0)` with `pow2(...)` across the codebase, particularly in high-frequency rendering and shadow compute shaders.
