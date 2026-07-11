## 2024-05-24 - Avoid pow(x, 2) macro evaluation
**Learning:** In GLSL, pow(x, 2) translates to an expensive mathematical function, while pow2(x) is natively optimized (x * x) in common.glsl.
**Action:** Always replace pow(..., 2) or pow(..., 2.0) with pow2(...) for better lighting and rendering performance without quality loss.
