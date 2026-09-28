## 2024-09-28 - Saturate Instruction Optimization
**Learning:** Found unoptimized division operations like `clamp(x + c, 0.0, max) / max`. Optimizing these to `clamp(x * (1.0/max) + (c/max), 0.0, 1.0)` replaces expensive division with multiplication and enables the compiler to use a free `saturate` instruction modifier for the `[0.0, 1.0]` range.
**Action:** Use this transformation for variables such as `sunFactor` and `sunVisibility` across the shaderpack to maximize performance.
