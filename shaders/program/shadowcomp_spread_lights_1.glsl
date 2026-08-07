#include "/lib/common.glsl"

const ivec3 workGroups = ivec3(65536, 1, 1);

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

#define WRITE_TO_SSBOS
#include "/lib/vx/SSBOs.glsl"

void main() {
	if (gl_GlobalInvocationID.x >= numLights) return;
	light_t thisLight = lights[gl_GlobalInvocationID.x];
	ivec3 coords = ivec3(thisLight.pos / POINTER_VOLUME_RES + vec3(pointerGridSize) / 2.0) / 4;
	int lightlevel = thisLight.brightnessMat >> 16;
		ivec3 lowerBound = max(coords - lightlevel / int(4.01 * POINTER_VOLUME_RES) - 1, ivec3(0));
		ivec3 upperBound = min(coords + lightlevel / int(4.01 * POINTER_VOLUME_RES) + 1, pointerGridSize / 4);
		for (int x = lowerBound.x; x <= upperBound.x; x++) {
			for (int y = lowerBound.y; y <= upperBound.y; y++) {
				for (int z = lowerBound.z; z <= upperBound.z; z++) {
					int globalCoord = readVolumePointer(ivec3(x, y, z), 5);
					// Fix: read capacity BEFORE atomic-increment to prevent
					// out-of-bounds write into the next cell's data when
					// multiple invocations race on the same slot. (#3)
					int capacity = readVolumePointer(ivec3(x, y, z), 4);
					int localCoord = incrementLightPointer(globalCoord);
					if (localCoord <= capacity)
						writeLightPointer(globalCoord + localCoord, int(gl_GlobalInvocationID.x));
				}
			}
		}

}