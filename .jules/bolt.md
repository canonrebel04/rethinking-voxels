## 2024-05-24 - Loop Interchange for Invariant Variables
**Learning:** In GLSL shaders with nested loops, expensive calculations (like trigonometry or normalize) that depend on only one loop index can severely impact performance if placed inside the inner loop.
**Action:** Swap the loops (loop interchange) to move the independent loop inwards, extracting the loop-invariant variables to the outer loop to reduce recalculations from O(N*M) to O(N). Always verify `pow2(x)` is available before replacing `pow(x, 2.0)` to avoid macro evaluation issues.
