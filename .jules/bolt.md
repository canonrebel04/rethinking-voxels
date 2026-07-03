## 2026-07-03 - GLSL pow() micro-optimization
**Learning:** The memory states that for GLSL performance optimization, when replacing `pow(x, 2)`, extracting the inner complex expression into a local variable and multiplying it by itself avoids macro double-evaluation risks and works safely across standard GLSL environments without introducing new custom functions.
**Action:** Replaced instances of `pow(max(0, 1 - dist/brightness), 2)` with a pattern using a new local variable representing the `max()` calculation multiplied by itself, saving computational expense while preserving behavior.
