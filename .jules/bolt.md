## 2024-05-24 - GLSL Constant Folding Optimization
**Learning:** Transforming expressions like clamp(x + c, 0.0, max_val) / max_val to clamp(x * (1.0/max_val) + (c/max_val), 0.0, 1.0) replaces division with multiplication and leverages a free 'saturate' instruction modifier for the [0.0, 1.0] range in modern GPU architectures.
**Action:** Always refactor constant denominator division in clamp parameters to reciprocal multiplication scaled by 1.0 to leverage native saturate hardware instructions.
