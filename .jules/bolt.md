## 2024-05-13 - Eliminate division by constant in GLSL shaders
**Learning:** Found multiple instances where values are calculated and then divided by constants (e.g., `clamp(SdotU + 0.375, 0.0, 0.75) / 0.75`). In GLSL shaders, division is computationally more expensive than multiplication.
**Action:** Replace divisions with equivalent operations using mathematically simplified multiplication to avoid the expensive division step. Specifically, I transformed `clamp(x + c1, 0.0, c2) / c2` into `clamp(x * (1.0/c2) + (c1/c2), 0.0, 1.0)`.
