## 2024-05-18 - Replacing `pow(x, 2.0)` with `pow2(x)` or `x * x`

**Learning:** GLSL's `pow(x, y)` is expensive. Many places use `pow(x, 2.0)` when they could simply be using the built-in fast path (like a macro or squaring directly). I should extract the expression to a local variable to safely square it if it's complex, or simply replace it with `pow2(x)` if `pow2` is defined in the context. However, the codebase has many `pow2` macro calls already, suggesting `pow2()` is heavily used as an optimization. When replacing `pow(x, 2.0)`, explicitly extracting complex expressions into a local variable and multiplying it by itself avoids macro double-evaluation risks associated with custom functions like `pow2(x)`.

**Action:** Look for `pow(..., 2.0)` or `pow(..., 2)` to replace.
