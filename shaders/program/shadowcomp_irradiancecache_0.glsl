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
	if (length(floor(thisLight.pos / 8) - floor(pos0 / 8)) < 0.1) return true;
	vec3 dir = thisLight.pos - pos0;
	float brightness = length(dir);
	float lightBrightness = thisLight.brightnessMat >> 16;
	float atten = max(0.0, 1.0 - brightness / lightBrightness);
	brightness = 0.0625 * lightBrightness * (atten * atten);
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
	const mat3 eye = mat3(1);
	ivec3 camOffset = ivec3(8.01 * (floor(0.125 * cameraPosition) - floor(0.125 * previousCameraPosition)));
	const ivec3 totalSize = ivec3(16, 8, 16);
	ivec3 iGlobalInvocationID = ivec3(gl_GlobalInvocationID);
	iGlobalInvocationID = // This is a horrible hack that assumes execution order of threads. If the irradiance
		iGlobalInvocationID * ivec3(greaterThan(camOffset, ivec3(-1))) + // cache breaks in movement on some hardware,
		(totalSize - iGlobalInvocationID - 1) * ivec3(lessThan(camOffset, ivec3(0))); // investigate this first
	iGlobalInvocationID = 8 * iGlobalInvocationID + ivec3(7.9 * hash44(vec4(iGlobalInvocationID + 0.5, frameCounter)));
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
