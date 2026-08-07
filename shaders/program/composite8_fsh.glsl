#include "/lib/common.glsl"

// Opt-in: define BLOCKLIGHT_FSR1 in shaders.properties to enable FSR1 upscaling. (#19)
// When enabled, the quarter-res block-light buffer (colortex4) is upscaled with
// edge-adaptive spatial upsampling (EASU) before the TAA blend, and RCAS sharpening
// is applied to the final result.
#include "/lib/misc/fsrUpscale.glsl"

#if BL_SHADOW_MODE == 1
flat in mat4 reprojectionMatrix;
in vec2 texCoord;

uniform int frameCounter;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D colortex2;
uniform sampler2D colortex4;
uniform sampler2D colortex12;

uniform float viewWidth;
uniform float viewHeight;
vec2 view = vec2(viewWidth, viewHeight);

uniform float near;
uniform float far;

float GetLinearDepth(float depth) {
	return (2.0 * near) / (far + near - depth * (far - near));
}

ivec2 offsets[4] = ivec2[4](ivec2(0, 0), ivec2(0, 1), ivec2(1, 1), ivec2(1, 0));
#endif
void main() {
	#if BL_SHADOW_MODE == 1
	ivec2 pixelCoord = ivec2(gl_FragCoord.xy);
	vec2 HRTexCoord = (pixelCoord - offsets[frameCounter % 4]) / (2.0 * view);
	// FSR1 EASU: edge-adaptive spatial upsampling from quarter-res to full-res.
	// Falls back to bilinear (texture2D) when BLOCKLIGHT_FSR1 is not defined. (#19)
	#ifdef BLOCKLIGHT_FSR1
		vec2 srcRes = view * 0.25; // colortex4 is rendered at quarter resolution
		vec3 col = fsrEASU(colortex4, HRTexCoord, srcRes);
	#else
		vec3 col = texture2D(colortex4, HRTexCoord).rgb;
	#endif
	float depth = texelFetch(depthtex1, pixelCoord, 0).r;
	vec4 prevPos = reprojectionMatrix * (vec4(texCoord, depth, 1) * 2 - 1);
	prevPos = prevPos * 0.5 / prevPos.w + 0.5;
	vec4 prevCol = texture2D(colortex12, prevPos.xy);
	// Temporal accumulation — guarded by BLOCKLIGHT_TAA toggle. (#11)
	#ifdef BLOCKLIGHT_TAA
		float blendFactor = 1.0; // target blend; curve below caps it at 0.92
		float prevDepth0 = GetLinearDepth(prevPos.z);
		float prevDepth1 = GetLinearDepth(texture2D(colortex12, prevPos.xy).a);
		float ddepth = abs(prevDepth0 - prevDepth1) / max(abs(prevDepth0), 0.001);
		float offCenterLength = length(fract(view * HRTexCoord) - 0.5);
		// Blend up to 0.92 (~12.5x sample count); zero on depth mismatch (ghosting rejection)
		blendFactor = clamp(blendFactor * (0.5 + 0.5 * offCenterLength) - 3.0 * float(ddepth > 0.2), 0.0, 0.92);
		col = mix(col, prevCol.xyz, blendFactor);
	#endif
	// RCAS: contrast-adaptive sharpening on the (optionally TAA-blended) result. (#19)
	// Strength controlled by BLOCKLIGHT_FSR1_SHARPNESS slider (default 0.25).
	#ifdef BLOCKLIGHT_FSR1
		col = fsrRCAS(col, colortex12, gl_FragCoord.xy / view, view, BLOCKLIGHT_FSR1_SHARPNESS);
	#endif
	#else
	vec3 col = vec3(0);
	float depth = 1.0;
	#endif
	/*RENDERTARGETS:12*/
	gl_FragData[0] = vec4(col, depth);
	return;
}