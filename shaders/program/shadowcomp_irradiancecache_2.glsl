#include "/lib/common.glsl"

const ivec3 workGroups = ivec3(16, 8, 16);

layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;

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
	vec3 dir = thisLight.pos - pos0;
	float lightBrightness = thisLight.brightnessMat >> 16;
	float t = max(0.0, 1.0 - length(dir) / lightBrightness);
	float brightness = 0.0625 * lightBrightness * t * t;
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
	const ivec3 totalSize = int(POINTER_VOLUME_RES + 0.5) * pointerGridSize;
	ivec3 iGlobalInvocationID = ivec3(gl_GlobalInvocationID);
	iGlobalInvocationID = // This is a horrible hack that assumes execution order of threads. If the irradiance
		iGlobalInvocationID * ivec3(greaterThan(camOffset, ivec3(-1))) + // cache breaks in movement on some hardware,
		(totalSize - iGlobalInvocationID - 1) * ivec3(lessThan(camOffset, ivec3(0))); // investigate this first
	ivec3 referenceCoord = ivec3(gl_WorkGroupID);
	referenceCoord = // This is a horrible hack that assumes execution order of threads. If the irradiance
		referenceCoord * ivec3(greaterThan(camOffset, ivec3(-1))) + // cache breaks in movement on some hardware,
		(ivec3(16, 8, 16) - referenceCoord - 1) * ivec3(lessThan(camOffset, ivec3(0))); // investigate this first
	referenceCoord = 8 * referenceCoord +
	ivec3(7.9 * hash44(vec4(referenceCoord + 0.5, frameCounter))) +
	ivec3(8.01 * (floor(0.125 * cameraPosition) - floor(0.125 * previousCameraPosition)));
	ivec3 oldCacheCoord = iGlobalInvocationID + camOffset;
	
	vec3 pos = iGlobalInvocationID - POINTER_VOLUME_RES * pointerGridSize / 2.0;
	vec4 hash0 = hash44(vec4(pos, frameCounter));
	pos += 0.5;//0.4 + 0.2 * hash0.xyz;

	ivec3 pgc = iGlobalInvocationID / int(POINTER_VOLUME_RES + 0.5) >> 2;
	int lightStripLoc = readVolumePointer(pgc, 5) + 1;
	int lightCount = readVolumePointer(pgc, 4);
	int lightNum = frameCounter % lightCount;
	uvec4 referenceData = readOcclusionVolume(referenceCoord);
	uvec4 occlusionData = readOcclusionVolume(oldCacheCoord);
	if (referenceData[2] == 0) {
		if ((referenceData[lightNum/32] >> (lightNum%32)) % 2 == 0)
			occlusionData[lightNum/32] &= 0xffffffffu - (1u<<(lightNum%32));
		else
			occlusionData[lightNum/32] |= 1u<<(lightNum%32);
	} else {
		if (getOcclusion(readLightPointer(lightStripLoc + lightNum), pos)) {
			occlusionData[lightNum/32] |= 1u<<(lightNum%32);
		} else {
			occlusionData[lightNum/32] &= 0xffffffffu - (1u<<(lightNum%32));
		}
	}
	writeOcclusionVolume(iGlobalInvocationID, occlusionData);
}

#else
void main() {}
#endif
