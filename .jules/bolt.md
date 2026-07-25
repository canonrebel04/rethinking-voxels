## 2024-05-24 - Avoid pow(x, 2) in GLSL for better performance
**Learning:** In GLSL, using `pow(x, 2)` calls an expensive generic power function. Using the custom `pow2(x)` function (which correctly maps to `x * x`) provided in `common.glsl` avoids this overhead.
**Action:** Always prefer `pow2(x)` over `pow(x, 2.0)` or `pow(x, 2)` when optimizing GLSL code where `common.glsl` is in scope, ensuring floating point literals like `0.0` and `1.0` are used to prevent type mismatches.
