## 2024-10-26 - FMA and saturate in GLSL
**Learning:** In GLSL shaders, division wrapped in clamp(..., 0.0, 1.0) can be replaced with multiplication by reciprocal to enable the compiler to use a free saturate instruction modifier, avoiding expensive float division.
**Action:** Always refactor `clamp(x / y, 0.0, 1.0)` into `clamp(x * (1.0 / y), 0.0, 1.0)` and tag with `/* Opt: FMA + saturate */`.
