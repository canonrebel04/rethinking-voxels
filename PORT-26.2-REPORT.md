# Rethinking Voxels → MC 26.2 Port Report (2026-08-31)

## Merge executed
- Branch `port-26.2`, merge of `cr-main` (Complementary r5.8.1-era, 0e300e1) into RV r0.1-beta9 base, merge-base `upstream/v1.3-update` (r5.3)
- 322 files changed, 49 conflict files resolved, commit 89f66ba

## Resolution decisions
- **RV kept (ours)**: `shaders.properties`, `shadowcomp.glsl`, all 89 RV-added voxelization/SSBO files (shadowcomp*, prepare*, lib/voxelization/*, lib/vx/*)
- **Complementary taken (theirs)**: `deferred1.glsl`, `composite.glsl`, `taa.glsl`, `reflections.glsl`, `blocklightColors.glsl`, `shadowSampling.glsl`, `terrainMaterials.glsl`, `block.properties` — 26.2 pipeline adaptations; verified these carried NO direct voxel hooks in beta9 (integration lives in mainLighting/common, preserved)
- **Union auto-resolved**: remaining 39 files (every hunk had one side unchanged vs merge-base)
- `en_US.lang`: union merged (1528 lines; both RV voxel options and Complementary 26.2 options present)

## Verification
- 0 conflict markers in shaders/
- #if/#endif balanced in all 10 heavy files (common.glsl 78/78, mainLighting 88/88, shadow.glsl 53/53, deferred1 62/62, composite 15/15, gbuffers_terrain 59/59, etc.)
- RV voxel pipeline intact: `mainLighting.glsl` keeps voxelization include, voxelFactor, readSurfaceVoxelBlocklight, colortex12 blocklight reads; all 21 voxel-referencing files present (shadowcomp*, prepare3/4, lib/vx/*, volumetricBlocklight.glsl)

## Unresolved / needs in-game testing
1. **colortex12 blocklight buffer**: verify Complementary 26.2 buffer layout doesn't renumber colortex attachments (Iris now documents 32 colortexes)
2. **reflections.glsl (theirs)**: RV worldSpaceRef/voxelReading callers must match new signatures — spot-checked getVoxelResolution OK; full GLSL compile only in-game
3. **VL_CLOUDS_ACTIVE in deferred1**: Complementary's new volumetric clouds path may double-compute with RV's volumetricBlocklight in composite1
4. **Custom images / SSBO binding names** in shaders.properties: confirm Iris 1.11.2 accepts RV's bindings under 26.2
