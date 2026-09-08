## 2024-09-08 - GGX Optimization
**Learning:** The GGX BRDF calculation has sequential divisions and `pow2` operations that can be mathematically reduced: `roughness / (pi * pow2(denom)) * F / pow2(dotLH)`.
**Action:** Simplified the formula to `roughness * F * (1/pi) / pow2(denom * dotLH)`, saving a division and a `pow2` function call in a hot path.
