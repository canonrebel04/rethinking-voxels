#include "/lib/common.glsl"

const ivec3 workGroups = ivec3(16, 8, 16);

layout(local_size_x = 3, local_size_y = 3, local_size_z = 3) in;

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

shared int visibility;
	void main() {
	if (gl_LocalInvocationID == uvec3(0))
		visibility = 0;
	barrier();
	groupMemoryBarrier();
	ivec3 camOffset = ivec3(8.01 * (floor(0.125 * cameraPosition) - floor(0.125 * previousCameraPosition)));
	const ivec3 totalSize = workGroups;
	// Safe scroll: use camOffset only for READ address (oldCacheCoord), not to reorder dispatch. (#1)
	ivec3 iGlobalInvocationID0 = ivec3(gl_WorkGroupID);
	ivec3 iGlobalInvocationID = 8 * iGlobalInvocationID0 + ivec3(7.9 * hash44(vec4(iGlobalInvocationID0 + 0.5, frameCounter)));
	ivec3 thisCoord = iGlobalInvocationID0 + ivec3(gl_LocalInvocationID) - 1;
	thisCoord = 8 * thisCoord + ivec3(7.9 * hash44(vec4(thisCoord + 0.5, frameCounter)));
	ivec3 oldCacheCoord = thisCoord + camOffset;
	ivec3 pgc0 = iGlobalInvocationID / int(POINTER_VOLUME_RES + 0.5) >> 2;
	ivec3 pgc = thisCoord / int(POINTER_VOLUME_RES + 0.5) >> 2;
	int lightCount0 = min(64, readVolumePointer(pgc0, 4));
	int lightStripLoc0 = readVolumePointer(pgc0, 5) + 1;
	int lightNum0 = frameCounter % lightCount0;
	int lightPointer = readLightPointer(lightStripLoc0 + lightNum0);

	int lightCount = min(64, readVolumePointer(pgc, 4));
	int lightStripLoc = readVolumePointer(pgc, 5) + 1;
	int lightNum;
	for (
		lightNum = 0;
		lightNum < lightCount && readLightPointer(lightStripLoc + lightNum) != lightPointer;
		lightNum++);

	uvec4 occlusionData = readOcclusionVolume(oldCacheCoord);
	if ((occlusionData[lightNum/32] >> (lightNum%32)) % 2 == 1 && lightNum < lightCount)
		atomicAdd(visibility, 1);
	barrier();
	groupMemoryBarrier();
	if (gl_LocalInvocationID == uvec3(1)) {
		if (visibility == 0 || visibility == 27)
			occlusionData[2] = 0;
		else
			occlusionData[2] = 1;
		writeOcclusionVolume(oldCacheCoord, occlusionData);
	}
}

#else
void main() {}
#endif
