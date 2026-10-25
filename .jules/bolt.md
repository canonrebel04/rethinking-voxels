## 2024-05-24 - FMA + Saturate Optimization in GLSL
**Learning:** In GLSL shaders, optimizing expressions like `clamp(x + c, 0.0, max_val) / max_val` to `clamp(x * (1.0/max_val) + (c/max_val), 0.0, 1.0)` not only replaces expensive division with multiplication but also enables the compiler to optimize using a free `saturate` instruction modifier for the `[0.0, 1.0]` range.
**Action:** Apply this transformation in hot paths to minimize instructions.
