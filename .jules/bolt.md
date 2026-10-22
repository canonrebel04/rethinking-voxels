## 2023-10-24 - FMA + saturate optimizations
**Learning:** Found multiple instances of `clamp(x + c, 0.0, max) / max`. We can change this to `clamp(x * (1.0/max) + (c/max), 0.0, 1.0)` to utilize FMA + saturate optimizations in the GPU and save division operations.
**Action:** When finding divisions of clamped values by max, optimize it algebraically and add the comment `/* Opt: FMA + saturate */`.
