## 2024-06-25 - FMA + saturate optimizations in GLSL
**Learning:** Found common hot-path expressions in shader files calculating `sunFactor` and `sunVisibility` utilizing expensive division and unoptimized clamping: `clamp(x + c, 0.0, max_val) / max_val`.
**Action:** Replaced division with multiplication and leveraged the `[0.0, 1.0]` bounds for `saturate` instruction modifier optimizations by reshaping expressions algebraically (e.g., `clamp(SdotU * 8.0 + 0.5, 0.0, 1.0) /* Opt: FMA + saturate */`).
