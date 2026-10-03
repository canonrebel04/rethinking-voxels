## 2024-10-03 - Optimize clamp for saturate instruction
**Learning:** In GLSL shaders, optimizing `clamp(x + c, 0.0, max_val) / max_val` to `clamp(x * (1.0/max_val) + (c/max_val), 0.0, 1.0)` not only replaces expensive division with multiplication but also enables the compiler to optimize using a free `saturate` instruction modifier for the `[0.0, 1.0]` range.
**Action:** Replace `sunFactor` and `sunVisibility` clamp patterns with mathematically equivalent versions that map strictly to the `[0.0, 1.0]` range using multiplication to leverage `saturate`.
