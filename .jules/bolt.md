## 2024-05-18 - Loop Interchange Optimization in Shaders
**Learning:** In GLSL shaders, when nested loops have computationally expensive operations (like trigonometry and normalize) that only depend on the inner loop counter, loop interchange can drastically reduce instructions from O(N*M) to O(N).
**Action:** Always check nested loops for loop-invariant variables and perform loop interchange to bring independent loops inward.
