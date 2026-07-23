## 2023-10-27 - Fast GLSL Exponentiation
**Learning:** In GLSL, standard `pow(x, 2)` can be significantly slower than direct multiplication, and mixing integer literals (like 0 or 1) with floats inside mathematical functions can cause implicit casting issues. Using the project's custom `pow2()` function from `common.glsl` and explicit float literals (0.0, 1.0) is much more performant and type-safe.
**Action:** Always prefer `pow2(x)` or `x * x` over `pow(x, 2.0)` and explicitly cast all numeric literals to floats (`0.0`, `1.0`) when dealing with float operations in shaders.
