## 2024-05-19 - Use pow2(x) instead of pow(x, 2)
**Learning:** `pow(x, y)` has noticeable performance overhead over direct multiplication, especially in fragment shaders that compute per-pixel. Since `common.glsl` provides overloaded `pow2(x)` functions which safely square the input, we should prefer `pow2(x)` whenever squaring. This is safer than macro replacement which could double-evaluate the parameter, and faster than generic `pow`.
**Action:** Replace `pow(..., 2)` with `pow2(...)` across GLSL shader files when `common.glsl` is in scope (which it is for almost all shaders).
