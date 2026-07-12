## 2026-07-12 - GLSL pow() Optimizations
**Learning:** In GLSL, using pow(x, 2.0) is generally less efficient than x * x. Also, integer to float casting (e.g. float(i)) must be explicit when used with overloaded functions like pow2() to avoid type mismatch errors, and library files might not always include common.glsl making pow2() unavailable.
**Action:** Always replace pow(x, 2.0) with pow2(x) if common.glsl is included, explicitly casting ints to float. If common.glsl is not in scope, extract the expression to a local variable and multiply it by itself.
