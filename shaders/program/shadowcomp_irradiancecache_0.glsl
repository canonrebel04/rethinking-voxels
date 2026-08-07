#include "/lib/common.glsl"

const ivec3 workGroups = ivec3(4, 2, 4);

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

#ifdef IRRADIANCECACHE

#define WRITE_TO_SSBOS
#include "/lib/vx/SSBOs.glsl"
#include "/lib/vx/raytrace.glsl"

uniform sampler2D colortex15;
uniform int frameCounter;
uniform float frameTime;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

// david hoskins' hash function with inlined coefficients
vec4 hash44(vec4 p) {
	uvec4 q = uvec4(ivec4(p)) * uvec4(1597334673U, 3812015801U, 2798796415U, 1979697957U);
	q = (q.x ^ q.y ^ q.z ^ q.w) * uvec4(1597334673U, 3812015801U, 2798796415U, 1979697957U);
	return vec4(q) / 4294967295.0;
}

bool getOcclusion(int lightPointer, vec3 pos0) {
	light_t thisLight = lights[lightPointer];
	// Fix #12: replaced the coarse "same 8-unit cell = always visible" early-return
	// with a per-voxel check. The old check caused light to bleed through single-block
	// walls whenever the light and the sample were in the same 8×8×8 macro-cell.
	// Now we only skip ray-tracing if the light is in the exact same voxel as the sample.
	if (all(equal(ivec3(floor(thisLight.pos)), ivec3(floor(pos0))))) return true;
	vec3 dir = thisLight.pos - pos0;
	float brightness = length(dir);
	float lightBrightness = thisLight.brightnessMat >> 16;
	brightness = 0.0625 * lightBrightness * pow2(max(0.0, 1.0 - brightness / lightBrightness));
	if (brightness < 0.01) return false;
	#ifdef ACCURATE_RT
		ray_hit_t rayHit = betterRayTrace(pos0, dir, colortex15);
	#else
		ray_hit_t rayHit = raytrace(pos0, dir, colortex15);
	#endif
	vec3 dist = abs(rayHit.pos - thisLight.pos) / (max(thisLight.size, vec3(0.5)) + 0.05);
	return all(lessThan(dist, vec3(1.0)));
}

void main() {
	// Safe camera-scroll: instead of relying on undefined GPU execution order,
	// we compute oldCacheCoord (where to READ the previous frame's data from)
	// and write always to iGlobalInvocationID (the current coordinate).
	// This two-phase pattern is race-free: reads reference old data, writes go to new positions. (#1)
	ivec3 camOffset = ivec3(8.01 * (floor(0.125 * cameraPosition) - floor(0.125 * previousCameraPosition)));
	const ivec3 totalSize = ivec3(16, 8, 16) * int(POINTER_VOLUME_RES + 0.5);
	ivec3 iGlobalInvocationID = ivec3(gl_GlobalInvocationID);
	vec3 pos = iGlobalInvocationID - POINTER_VOLUME_RES * pointerGridSize / 2.0;
	vec4 hash0 = hash44(vec4(pos, frameCounter));
	pos += 0.5;//0.4 + 0.2 * hash0.xyz;
	ivec3 oldCacheCoord = iGlobalInvocationID + camOffset;
	ivec3 pgc = iGlobalInvocationID / int(POINTER_VOLUME_RES + 0.5) >> 2;
	int lightCount = min(64, readVolumePointer(pgc, 4));
	int lightStripLoc = readVolumePointer(pgc, 5) + 1;
	uvec4 occlusionData = readOcclusionVolume(oldCacheCoord);
	int lightNum = frameCounter % lightCount;
	if (getOcclusion(readLightPointer(lightStripLoc + lightNum), pos)) {
		occlusionData[lightNum/32] |= 1u<<(lightNum%32);
	} else {
		occlusionData[lightNum/32] &= 0xffffffffu - (1u<<(lightNum%32));
	}
	writeOcclusionVolume(oldCacheCoord, occlusionData);
}

#else
void main() {}
#endif
