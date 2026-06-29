## 2024-05-18 - Avoid pow(x, 2) and Implicit Casts in GLSL
**Learning:** Evaluating `pow(x, 2)` instead of `x * x` in GLSL can cause overhead if not aggressively optimized, and mixing integer constants like `0` inside `max()` with floats can cause subtle type compatibility issues or shader safety hazards on stricter compilers.
**Action:** Extract complex expressions inside `pow(..., 2)` into a local variable (e.g., `float t = max(0.0, 1.0 - ...);`) and multiply it by itself (`t * t`), using explicit `.0` floats.
