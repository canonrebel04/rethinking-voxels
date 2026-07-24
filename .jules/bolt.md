## 2024-05-18 - Replacing `pow(x, 2)` with `pow2(x)`
**Learning:** `pow2` is defined in `common.glsl` as an overloaded function for ints, floats, and vectors, returning `x * x`. Replacing `pow(x, 2)` (which uses a potentially expensive library function) with `pow2(x)` is a solid performance win for shaders where `common.glsl` is included.
**Action:** Replace `pow(x, 2)` and `pow(x, 2.0)` with `pow2(x)` in files that include `common.glsl`, particularly in loops or frequently executed paths.
