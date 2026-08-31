## 2024-05-24 - Optimizing `pow(x, 2.0)` in GLSL
**Learning:** In GLSL, using `pow(x, 2.0)` is computationally more expensive than simple multiplication `x * x` or using `pow2(x)` if it's defined (which avoids double evaluation risks of macros since it's an overloaded function).
**Action:** Replace `pow(x, 2.0)` with `pow2(x)` or `(x * x)` in shaders to reduce arithmetic instruction count without sacrificing readability, especially inside loops like in `endPortalEffect.glsl` and `lensFlare.glsl`.
