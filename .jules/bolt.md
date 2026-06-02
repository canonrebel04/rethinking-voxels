## 2024-05-24 - GLSL pow() function optimization
**Learning:** Standard pow(x, 2.0) is slow in GLSL compared to simple multiplication or the codebase's custom pow2(x) implementation in shaders/lib/common.glsl.
**Action:** Replace instances of pow(x, 2) or pow(x, 2.0) with pow2(x) across GLSL files to optimize performance.
