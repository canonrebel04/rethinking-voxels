// fsrUpscale.glsl
// FidelityFX Super Resolution 1.0 (FSR1) — GLSL implementation
// Ported from AMD GPUOpen FSR HLSL reference, simplified for GLSL fragment shaders.
// Reference: https://gpuopen.com/fidelityfx-superresolution/
//
// Usage:
//   #define BLOCKLIGHT_FSR1  to enable FSR1 upscaling in composite_light_accum_fsh.
//   Call  fsrEASU(sampler, texcoord, srcResolution)  in place of texture2D().
//   Optionally call  fsrRCAS(color, src, uv, dstRes, sharpness)  afterwards.

#ifdef BLOCKLIGHT_FSR1

// ── EASU — Edge Adaptive Spatial Upsampling ──────────────────────────────────
// Samples a 4-tap bilinear neighbourhood weighted by local luma edge gradients.
// src    : the LOW-resolution block-light sampler
// uv     : destination UV in [0,1]
// srcRes : resolution of src (vec2)

float fsrLuma(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

vec3 fsrEASU(sampler2D src, vec2 uv, vec2 srcRes) {
    vec2 invSrcRes = 1.0 / srcRes;
    vec2 srcUV  = uv * srcRes - 0.5;
    vec2 srcFlr = floor(srcUV);
    vec2 f      = srcUV - srcFlr;

    vec2 p00 = (srcFlr + vec2(0.0, 0.0) + 0.5) * invSrcRes;
    vec2 p10 = (srcFlr + vec2(1.0, 0.0) + 0.5) * invSrcRes;
    vec2 p01 = (srcFlr + vec2(0.0, 1.0) + 0.5) * invSrcRes;
    vec2 p11 = (srcFlr + vec2(1.0, 1.0) + 0.5) * invSrcRes;

    vec3 c00 = texture2DLod(src, p00, 0.0).rgb;
    vec3 c10 = texture2DLod(src, p10, 0.0).rgb;
    vec3 c01 = texture2DLod(src, p01, 0.0).rgb;
    vec3 c11 = texture2DLod(src, p11, 0.0).rgb;

    float l00 = fsrLuma(c00), l10 = fsrLuma(c10);
    float l01 = fsrLuma(c01), l11 = fsrLuma(c11);

    float w00 = (1.0 - f.x) * (1.0 - f.y);
    float w10 =        f.x  * (1.0 - f.y);
    float w01 = (1.0 - f.x) *        f.y;
    float w11 =        f.x  *        f.y;

    float lCentre = w00*l00 + w10*l10 + w01*l01 + w11*l11;
    float edc = 4.0; // edge discrimination: higher = sharper edge boundary
    float ew00 = w00 / (1.0 + edc * abs(l00 - lCentre));
    float ew10 = w10 / (1.0 + edc * abs(l10 - lCentre));
    float ew01 = w01 / (1.0 + edc * abs(l01 - lCentre));
    float ew11 = w11 / (1.0 + edc * abs(l11 - lCentre));

    float totalW = ew00 + ew10 + ew01 + ew11;
    return (ew00*c00 + ew10*c10 + ew01*c01 + ew11*c11) / max(totalW, 0.0001);
}

// ── RCAS — Robust Contrast Adaptive Sharpening ───────────────────────────────
// col      : colour to sharpen (result of fsrEASU or TAA blend)
// src      : the same resolved buffer as a sampler
// uv       : destination UV in [0,1]
// dstRes   : output resolution
// sharpness: [0,1]; 0 = off, 0.25 = default

vec3 fsrRCAS(vec3 col, sampler2D src, vec2 uv, vec2 dstRes, float sharpness) {
    vec2 d = 1.0 / dstRes;
    vec3 cN = texture2DLod(src, uv + vec2( 0.0,  d.y), 0.0).rgb;
    vec3 cS = texture2DLod(src, uv + vec2( 0.0, -d.y), 0.0).rgb;
    vec3 cE = texture2DLod(src, uv + vec2( d.x,  0.0), 0.0).rgb;
    vec3 cW = texture2DLod(src, uv + vec2(-d.x,  0.0), 0.0).rgb;

    float lN = fsrLuma(cN), lS = fsrLuma(cS);
    float lE = fsrLuma(cE), lW = fsrLuma(cW);
    float lC = fsrLuma(col);

    float lMin = min(lC, min(min(lN, lS), min(lE, lW)));
    float lMax = max(lC, max(max(lN, lS), max(lE, lW)));

    // Sharpening weight capped to prevent ringing on hard edges
    float rcas_d = max(0.0, 0.25 - 0.25 / (1.0 + max(0.0001, lMax - lMin)));
    rcas_d *= sharpness;
    return max(vec3(0.0), col + rcas_d * (col - 0.25 * (cN + cS + cE + cW)));
}

#endif // BLOCKLIGHT_FSR1
