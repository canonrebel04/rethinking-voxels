## 2024-05-23 - Optimize pow(x, 2) to pow2(x) in hot loop shaders
**Learning:** In GLSL shaders, using the built-in `pow(x, 2)` can be much slower than explicitly multiplying a value by itself, especially in tight loops like the irradiance cache shaders. Furthermore, mixing integers and floats in `max(0, ...)` can cause implicit cast issues depending on the compiler.
**Action:** Use the `pow2(x)` function from `common.glsl` (which evaluates as `x * x`) instead of `pow(x, 2)`, and ensure integer values are explicitly cast to floats (e.g., `max(0.0, ...)`).
