
## $(date +%Y-%m-%d) - Optimize pow() with exponent 2
**Learning:** Found usage of `pow(x, 2)` and `pow(x, 2.0)` in GLSL, which is slower than using multiplication directly because `pow` usually evaluates via `exp2(y * log2(x))`. This codebase has a faster `pow2` function in `shaders/lib/common.glsl`.
**Action:** Replace `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)` where `common.glsl` is included, or inline the multiplication if it's not.
