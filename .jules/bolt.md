## 2026-09-09 - GLSL Loop Interchange
**Learning:** In GLSL shaders, loop-invariant calculations (like trigonometric functions, normalize, and matrix math) that depend only on one loop index can be very expensive when nested inside a multi-pass loop. Swapping the inner and outer loops (loop interchange) to move the independent loop inwards significantly reduces recalculations from O(N*M) to O(N).
**Action:** Always check nested loops for variables that only depend on one loop index and restructure the loops to hoist these expensive calculations outward.
