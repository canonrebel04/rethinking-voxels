## 2024-05-30 - GLSL Optimizations (pow vs pow2)
**Learning:** Found a custom `pow2(x)` function in `shaders/lib/common.glsl` that utilizes `x * x` under the hood. Using `pow(x, 2)` or `pow(x, 2.0)` natively in GLSL falls back to using transcendental functions which can be significantly slower than a direct multiplication on GPU architectures.
**Action:** Replace all instances of `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)` across GLSL files to achieve a performance gain during shader compilation and execution without sacrificing readability.
