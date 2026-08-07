#ifndef SSBO
#define SSBO
#define LOCAL_MAX_TRIS 512
#define MAX_TRIS 524288
#define MAX_LIGHTS 65536
#define POINTER_VOLUME_RES 2.0

#ifndef WRITE_TO_SSBOS
#define WRITE_TO_SSBOS readonly
#define READONLY
#endif

const ivec3 pointerGridSize = ivec3(64, 32, 64);
const int maxStripIndex = MAX_TRIS + pointerGridSize.x * pointerGridSize.y * pointerGridSize.z;
struct tri_t {
	uint matBools;
	int bvhParent;
	uvec3 texCoord;
	uvec3 vertexCol;
	mat3 pos;
};
#ifdef ACCURATE_RT
	layout(std430, binding = 0) WRITE_TO_SSBOS buffer voxelData {
		int numFaces;
		tri_t tris[];
	};
#else
	layout(std430, binding = 0) WRITE_TO_SSBOS buffer voxelData {
		uvec4 voxelVolume[][2 * pointerGridSize.y][2 * pointerGridSize.z];
	};
	uvec4 readVoxelVolume(ivec3 coords, int index) {
		return voxelVolume[2 * pointerGridSize.x * index + coords.x][coords.y][coords.z];
	}
	#ifndef READONLY 
		void writeVoxelVolume(ivec3 coords, int index, uvec4 data) {
			voxelVolume[2 * pointerGridSize.x * index + coords.x][coords.y][coords.z] = data;
		}
		uint maxVoxelVolume(ivec3 coords, int index, int component, uint data) {
			return atomicMax(voxelVolume[2 * pointerGridSize.x * index + coords.x][coords.y][coords.z][component], data);
		}
	#endif
#endif

// Irradiance cache
#ifdef READONLY
	uniform sampler3D irradianceCache;
	vec3 readIrradianceCache(vec3 vxPos, vec3 normal) {
		vec3 color = vec3(0);
		vec3 coord = vxPos / (POINTER_VOLUME_RES * pointerGridSize) + 0.5;
		// Divide by 7 to address the 7 directional slices stacked in Y.
		// The base coord.y lands on the first slice; add (slice + 0.5)/7 to centre on each texel. (#18)
		coord.y /= 7.0;
		for (int i = 0; i < 3; i++) {
			color += normal[i] * normal[i] * textureLod(irradianceCache, coord + vec3(0, (float(i) + 3.0 * float(normal[i] > 0) + 0.5) / 7.0, 0), 0.0).xyz;
		}
		return color;
	}
	vec3 readIrradianceCache(vec3 vxPos, int index) {
		vec3 coord = vxPos / (POINTER_VOLUME_RES * pointerGridSize) + 0.5;
		coord.y /= 7.0;
		return textureLod(irradianceCache, coord + vec3(0, (float(index) + 0.5) / 7.0, 0), 0.0).xyz;
	}
#else
layout(rgba16f) uniform image3D irradianceCacheI;
layout(rgba32ui)uniform uimage3D occlusionVolumeI;
	vec4 readIrradianceCache(ivec3 coord, int index) {
		return imageLoad(irradianceCacheI, coord + ivec3(0, int(0.5 + POINTER_VOLUME_RES) * pointerGridSize.y * index, 0));
	}
	void writeIrradianceCache(ivec3 coord, int index, vec4 data) {
		imageStore(irradianceCacheI, coord + ivec3(0, int(0.5 + POINTER_VOLUME_RES) * pointerGridSize.y * index, 0), data);
	}
	uvec4 readOcclusionVolume(ivec3 coord) {
		return imageLoad(occlusionVolumeI, coord);
	}
	void writeOcclusionVolume(ivec3 coord, uvec4 data) {
		imageStore(occlusionVolumeI, coord, data);
	}
#endif

layout(std430, binding = 1) WRITE_TO_SSBOS buffer volumePointers {
	int wtrxmskskosfke;
	//int pointerVolume[][pointerGridSize.x][pointerGridSize.y][pointerGridSize.z];
};

struct light_t {
	vec3 pos;
	vec3 size;
	int packedColor;
	int brightnessMat;
};
layout(std430, binding = 2) WRITE_TO_SSBOS buffer lightData {
	int numLights;
	light_t lights[];
};

layout(std430, binding = 3) WRITE_TO_SSBOS buffer misc {
	mat4 gbufferPreviousModelViewInverse;
	mat4 gbufferPreviousProjectionInverse;
	vec3[4] frustrumSideNormals;
	//int pointerStrip[];
};

// 3D pointer storage
layout(r32i) uniform WRITE_TO_SSBOS iimage3D pointerVolumeI;
int readVolumePointer(ivec3 coords, int index) {
	return imageLoad(pointerVolumeI, ivec3(coords.x, 8 * coords.y + index, coords.z)).x;
	//return pointerVolume[index][coords.x][coords.y][coords.z];
}
#ifndef READONLY
	void writeVolumePointer(ivec3 coords, int index, int data) {
		imageStore(pointerVolumeI, ivec3(coords.x, 8 * coords.y + index, coords.z), ivec4(data));
		//pointerVolume[index][coords.x][coords.y][coords.z] = data;
	}
	int incrementVolumePointer(ivec3 coords, int index) {
		return imageAtomicAdd(pointerVolumeI, ivec3(coords.x, 8 * coords.y + index, coords.z), 1);
		//return atomicAdd(pointerVolume[index][coords.x][coords.y][coords.z], 1);
	}
#endif

// pseudo-1D data storage
layout(r32i) uniform WRITE_TO_SSBOS iimage2D pointerStripI;

int readTriPointer(int index) {
	return imageLoad(pointerStripI, ivec2(index % 2048, index / 2048)).x;
	//return pointerStrip[index];
}
#ifndef READONLY
	void writeTriPointer(int index, int data) {
		imageStore(pointerStripI, ivec2(index % 2048, index / 2048), ivec4(data));
		//pointerStrip[index] = data;
	}
	int incrementTriPointer(int index) {
		return imageAtomicAdd(pointerStripI, ivec2(index % 2048, index / 2048), 1);
		//return atomicAdd(pointerStrip[index], 1);
	}
#endif
int readLightPointer(int index) {
	return imageLoad(pointerStripI, ivec2(index % 2048, index / 2048 + 1024)).x;
	//return pointerStrip[index + 1048576];
}
#ifndef READONLY
	void writeLightPointer(int index, int data) {
		imageStore(pointerStripI, ivec2(index % 2048, index / 2048 + 1024), ivec4(data));
		//pointerStrip[index + 1048576] = data;
	}
	int incrementLightPointer(int index) {
		return imageAtomicAdd(pointerStripI, ivec2(index % 2048, index / 2048 + 1024), 1);
		//return atomicAdd(pointerStrip[index + 1048576], 1);
	}
#endif
#endif