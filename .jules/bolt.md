## 2024-05-24 - GLSL pow(x, 2) Performance Penalty
**Learning:** Standard `pow(x, 2)` or `pow(x, 2.0)` evaluates via slower `exp2(y * log2(x))` in GLSL, introducing unnecessary instruction overhead for simple squaring.
**Action:** Replace with `pow2(x)` from `common.glsl` or inline multiplication `(x * x)` to save cycles and improve performance.
