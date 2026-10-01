## 2024-10-24 - Optimize GLSL clamp divisions with saturate modifier
**Learning:** In GLSL shaders, optimizing expressions like `clamp(x + c, 0.0, max_val) / max_val` to `clamp(x * (1.0/max_val) + (c/max_val), 0.0, 1.0)` replaces expensive division with multiplication and enables the compiler to optimize using a free `saturate` instruction modifier for the `[0.0, 1.0]` range.
**Action:** Replaced division with constant multiplication in clamp expressions for `sunFactor` and `sunVisibility` calculations across all shader programs.
