## 2024-05-09 - Prefer pow2(x) over pow(x, 2)
**Learning:** The codebase defines a fast `pow2(x)` function in `shaders/lib/common.glsl` for squares. However, several shaders (like `prepare7_fsh.glsl`, `shadowcomp_irradiancecache_*.glsl`) still use `pow(x, 2)`, which is slower on some GPUs and not ideal for GLSL.
**Action:** Always prefer `pow2(x)` over `pow(x, 2)` or `pow(x, 2.0)` across GLSL shaders for better performance.
