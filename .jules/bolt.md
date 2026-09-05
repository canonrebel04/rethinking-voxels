## 2026-09-05 - Optimize pow(x, 2.0) macro usage
**Learning:** In GLSL shaders, `pow(x, 2.0)` function calls can often be optimized using a simpler multiplication or a dedicated `pow2` function to avoid potentially expensive underlying math routines in GLSL compilers.
**Action:** Replaced `pow(..., 2.0)` with `pow2(...)` (where `pow2` is available in `common.glsl`) or `x * x` to improve performance without impacting visuals.
