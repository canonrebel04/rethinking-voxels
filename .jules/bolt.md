## 2026-06-21 - GLSL pow() function
**Learning:** The standard pow() function is less efficient for powers of 2 because it evaluates via exp2(y * log2(x)). Using pow2(x) from common.glsl or multiplying directly is faster.
**Action:** Replaced instances of pow(x, 2) or pow(x, 2.0) with inline multiplication or pow2() for micro-optimization.
