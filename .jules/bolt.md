## 2024-05-18 - Replacing `pow(x, 2)` in shader calculations
**Learning:** In GLSL shaders, `pow(x, y)` is inherently expensive as it typically expands to `exp2(y * log2(x))`. For small integer powers like 2, replacing `pow(value, 2)` with simple multiplication (`value * value`) saves GPU cycles and improves performance in pixel-heavy computations (like per-fragment lighting loops).
**Action:** Always replace `pow(x, 2)` and `pow(x, 2.0)` with direct multiplication (`x * x`) in GLSL shaders for better performance without changing behavior.
