## 2024-05-14 - Prefer pow2() over pow(x, 2.0)
**Learning:** This codebase defines a faster `pow2(x)` function in `shaders/lib/common.glsl` that should be preferred over `pow(x, 2)` or `pow(x, 2.0)` for GLSL performance optimization. Using the built-in `pow()` for squaring is a common performance anti-pattern.
**Action:** Replace `pow(x, 2.0)` with `pow2(x)` throughout the codebase where applicable.
