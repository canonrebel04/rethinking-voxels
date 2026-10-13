## 2023-10-13 - Optimize division to multiplication and saturate
**Learning:** Replaced expensive division and clamp `clamp(x / max, 0.0, 1.0)` with a multiplication and clamp `clamp(x * (1.0/max), 0.0, 1.0)`. GLSL compilers can optimize `clamp(..., 0.0, 1.0)` into a free `saturate` instruction modifier, which is more efficient when paired with MAD instructions.
**Action:** Always prefer `clamp(a * b + c, 0.0, 1.0)` over `clamp(a + c*max, 0, max) / max` because the compiler uses MAD + SATURATE.
