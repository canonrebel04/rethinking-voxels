## 2024-06-12 - pow2 implementation check
**Learning:** `pow2` is indeed a custom function defined in `shaders/lib/common.glsl`, making it available everywhere that file is included. Files in `/lib/` generally don't include `common.glsl` directly because they are included in programs (like `final.glsl` or `gbuffers_block.glsl`) which already include `common.glsl` at the top.
**Action:** Always verify custom macro/function definitions and their inclusion scope within the shader program hierarchy before replacing standard GLSL functions.
