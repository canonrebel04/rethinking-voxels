## 2023-10-24 - Division by constant
**Learning:** In GLSL, division by a constant is less efficient than multiplication by its reciprocal. For example, `bloom / 128.0` requires division, while `bloom * 0.0078125` is purely multiplication.
**Action:** Replaced `pow(bloom / 128.0, vec3(0.25))` with `pow(bloom * 0.0078125, vec3(0.25))` to reduce division instruction in a hot path in `shaders/program/composite4.glsl`.
