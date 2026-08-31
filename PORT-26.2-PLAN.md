# Rethinking Voxels → Minecraft 26.2 Port Plan

## Current state
- `main` = upstream r0.1-beta9 (MC 1.21.10 era, Feb 2026)
- Iris 1.11.2 supports MC 26.2 (Fabric; use Sodium mc26.2-0.9.0, not 0.9.1-beta.2 — see Iris #3181)
- beta9 likely runs on 26.2 via Iris backcompat — TEST FIRST before porting

## Port (only if backcompat breaks)
- `port-26.2` branch = beta9 base
- Base for merge: Complementary r5.8.1-equivalent = upstream ComplementaryDevelopment main (fetched as local ref `cr-main`, 0e300e1, Aug 2026)
- Merge base: `upstream/v1.3-update` (r5.3, Sep 2024 — the Complementary version RV forked from)
- Delta: 226 Complementary commits; 322 changed files; 61 files touched by BOTH RV & Complementary (real merge work); 89 RV-added files (keep); ~37 RV-only modifications (keep)
- Conflict profile measured: 49 conflict files, ~180 hunks. Heaviest: common.glsl (15), en_US.lang (14), shaders.properties (10), shadow.glsl (10), mainLighting.glsl (9)
- Resolution policy: RV voxelization/SSBO code wins in RV-added files; Complementary wins for 26.2 pipeline changes; hand-merge the 61 overlap files
- Known 26.2 issues affecting shaders: copied-render-pipeline override lookup bug (Iris PR #3253), tess check fix (PR #3255, merged) — needs Iris 1.11.3+ or Iris from source

## Testing (no build system — shader pack)
1. Zip `shaders/` contents (shaders.properties at zip root's shaders/ folder)
2. Install: MC 26.2 + Fabric + Sodium 0.9.0 + Iris 1.11.2 → shaderpacks folder
3. Check log for compile errors per program; visually verify: blocklight shadows, voxel reflections, entity shadows
