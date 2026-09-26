## 2024-09-26 - [Initialization]
**Learning:** Initializing journal for Bolt persona.
**Action:** Always document critical learnings specific to this codebase.

## 2024-09-26 - [Vector Division by Constant Optimization]
**Learning:** In GLSL shaders, dividing a vector by a constant scalar (like `bloom / 128.0`) results in computationally expensive division instructions that compilers may not automatically convert to multiplication.
**Action:** Always replace vector division by a constant float with multiplication by its reciprocal (e.g., `bloom * 0.0078125`) to eliminate the division overhead entirely.
