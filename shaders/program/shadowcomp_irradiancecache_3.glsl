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

vec4 getLightCol(int lightPointer, inout vec3 pos0) {
	vec3 pos = pos0;
	light_t thisLight = lights[lightPointer];
	vec3 dir = thisLight.pos - pos;
	pos0 = dir;
	float brightness = length(dir);
	float lightBrightness = thisLight.brightnessMat >> 16;
	// Optimization: replace pow(..., 2) with faster pow2()
	brightness = 0.0625 * lightBrightness * pow2(max(0, 1 - brightness / lightBrightness));
	if (brightness < 0.01) return vec4(0);
	#ifdef ACCURATE_RT
		ray_hit_t rayHit = betterRayTrace(pos, dir, colortex15);
	#else
		ray_hit_t rayHit = raytrace(pos, dir, colortex15);
	#endif
	vec3 dist = abs(rayHit.pos - thisLight.pos) / (max(thisLight.size, vec3(0.5)) + 0.05);
	if (max(dist.x, max(dist.y, dist.z)) > 1.0) return vec4(0, 0, 0, brightness);
	if (rayHit.transColor.a < 0.1) rayHit.transColor = vec4(1);
	return vec4(
		vec3(thisLight.packedColor % 256,
		(thisLight.packedColor >> 8) % 256,
		(thisLight.packedColor >> 16) % 256) / 255.0 * brightness * rayHit.transColor.rgb,
		brightness);
}

shared vec4 lightCols[64];
shared vec3 lightPositions[64];

void main() {
	const mat3 eye = mat3(1);
	ivec3 camOffset = ivec3(8.01 * (floor(0.125 * cameraPosition) - floor(0.125 * previousCameraPosition)));
	const ivec3 totalSize = int(POINTER_VOLUME_RES + 0.5) * pointerGridSize;
	ivec3 iGlobalInvocationID = ivec3(gl_GlobalInvocationID);
	iGlobalInvocationID = // This is a horrible hack that assumes execution order of threads. If the irradiance
		iGlobalInvocationID * ivec3(greaterThan(camOffset, ivec3(-1))) + // cache breaks in movement on some hardware,
		(totalSize - iGlobalInvocationID - 1) * ivec3(lessThan(camOffset, ivec3(0))); // investigate this first
	vec3 pos = iGlobalInvocationID - POINTER_VOLUME_RES * pointerGridSize / 2.0;
	vec4 hash0 = hash44(vec4(pos, frameCounter));
	pos += 0.5;//0.4 + 0.2 * hash0.xyz;
	ivec3 oldCacheCoord = iGlobalInvocationID + camOffset;
	ivec3 pgc = iGlobalInvocationID / int(POINTER_VOLUME_RES + 0.5) >> 2;
	int lightCount = min(64, readVolumePointer(pgc, 4));
	if (gl_LocalInvocationID.z == 0) {
		int lightStripLoc = readVolumePointer(pgc, 5) + 1;
		int lightNum = int(gl_LocalInvocationID.x) + 8 * int(gl_LocalInvocationID.y);
		if (lightNum < lightCount) {
			light_t thisLight = lights[readLightPointer(lightStripLoc + lightNum)];
			lightPositions[lightNum] = thisLight.pos;
			lightCols[lightNum] = vec4(
				thisLight.packedColor % 256,
				(thisLight.packedColor >> 8) % 256,
				(thisLight.packedColor >> 16) % 256,
				thisLight.brightnessMat >> 16) / vec4(255, 255, 255, 1);
		}
	}
	barrier();
	groupMemoryBarrier();
	uvec4 occlusionData = readOcclusionVolume(iGlobalInvocationID);
	bool doLighting = (frameCounter + gl_WorkGroupID.x + gl_WorkGroupID.y + gl_WorkGroupID.z) % 10 == 0;
	vec4 irrCacheData[7];
	for (int k = 0; k < 7; k++) irrCacheData[k] = vec4(0);
	if (doLighting) {
		for (int n = 0; n < lightCount; n++) {
			if ((occlusionData[n/32] >> (n%32)) % 2 == 0) continue;
			vec3 dir = lightPositions[n] - pos;
			// Optimization: replace pow(..., 2) with faster pow2()
			float brightness = 0.0625 * lightCols[n].a * pow2(max(0, 1 - length(dir) / lightCols[n].a));
			if (brightness > 0.01) {
				vec4 thisAdjustedCol = vec4(lightCols[n].xyz, 1) * brightness;
				irrCacheData[6] += thisAdjustedCol;
				for (int k = 0; k < 3; k++) {
					if (abs(dir[k]) > 0.5) {
						int dirsgn = int(dir[k] > 0) * 2 - 1;
						irrCacheData[k + 3 * int(dir[k] > 0)] += abs(normalize(dir - 0.5 * dirsgn * eye[k]))[k] * thisAdjustedCol;
					} else {
						irrCacheData[k] += abs(normalize(dir - 0.5 * eye[k]))[k] * thisAdjustedCol;
						irrCacheData[k + 3] += abs(normalize(dir + 0.5 * eye[k]))[k] * thisAdjustedCol;
					}
				}
			}
		}
		float lightLen = max(max(irrCacheData[6].x, irrCacheData[6].y), irrCacheData[6].z);
		for (int k = 0; k < 7; k++) {
			irrCacheData[k] *= 3 * log(lightLen / 3.0 + 1) / (lightLen + 0.0001);
		}
	} else {
		for (int k = 0; k < 7; k++) irrCacheData[k] = readIrradianceCache(oldCacheCoord, k);
	}
	for (int k = 0; k < 7; k++) writeIrradianceCache(iGlobalInvocationID, k, irrCacheData[k]);
}

#else
void main() {}
#endif
