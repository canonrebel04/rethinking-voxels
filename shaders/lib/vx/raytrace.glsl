#ifndef RAYTRACE
	#define RAYTRACE
	#include "/lib/vx/SSBOs.glsl"
	//#include "/lib/vx/voxelMapping.glsl"
	#ifndef ACCURATE_RT
		#include "/lib/vx/voxelReading.glsl"
	#endif

	const mat3 eye = mat3(1.0);

	struct ray_hit_t {
		vec4 rayColor;
		vec4 transColor;
		int triId;
		int transTriId;
		vec3 pos;
		vec3 transPos;
		vec3 normal;
		vec3 transNormal;
	};

	#ifndef ACCURATE_RT
		// cuboid intersection algorithm
		float aabbIntersect(vxData data, vec3 pos, vec3 dir, inout int n) {
			float dirLen = max(length(dir), 0.00001);
			// offset to work around floating point errors
			vec3 offset = 0.001 * eye[n] * sign(dir[n]);
			// for connected blocks like walls, fences etc, figure out connection sides
			bool renderMainCuboid = true;
			bvec2 renderConnectCuboids = bvec2(false);
			vec3[4] connectCuboids = vec3[4](
				vec3(min(data.lower + 0.0625, 0.4375)),
				vec3(max(data.upper - 0.0625, 0.5625)),
				vec3(min(data.lower + 0.0625, 0.4375)),
				vec3(max(data.upper - 0.0625, 0.5625))
			);
			if (data.connectsides) {
				for (int k = 0; k < 4; k++) {
					connectCuboids[k].y = (k % 2 == 0) ? (abs(data.lower.x - 0.375) < 0.01 ? 0.375 : 0.0) : (abs(data.lower.x - 0.25) < 0.01 ? 0.875 : (abs(data.lower.x - 0.375) < 0.01 ? 0.9375 : 1.0));
					vec3 blockOffset = vec3(k % 2 * 2 - 1) * vec3(1 - (k >> 1), 0, k >> 1);
					vec3 thisOffsetPos = pos + offset + blockOffset;
					if (all(greaterThan(thisOffsetPos, -pointerGridSize * POINTER_VOLUME_RES / 2.0)) && all(lessThan(thisOffsetPos, pointerGridSize * POINTER_VOLUME_RES / 2.0))) {
						vxData offsetData = readVxMap(thisOffsetPos);
						if ((offsetData.connectsides && !(abs(offsetData.lower.x - 0.375) < 0.01 ^^ abs(data.lower.x - 0.375) < 0.01)) || (offsetData.full && !offsetData.alphatest)) {
							connectCuboids[k][2 * (k >> 1)] = k % 2;
							renderConnectCuboids[k >> 1] = true;
						}
					}
				}
				if (abs(data.lower.x - 0.25) < 0.01 && ((renderConnectCuboids == bvec2(true, false) && connectCuboids[0].x < 0.01 && connectCuboids[1].x > 0.99) || (renderConnectCuboids == bvec2(false, true) && connectCuboids[2].z < 0.01 && connectCuboids[3].z > 0.99))) renderMainCuboid = false;
			}
			// don't need to know global position, only relative to current block
			pos = fract(pos + offset) - offset;
			float w = 10000;
			for (int k = 0; k < 2; k++) {
				if (renderConnectCuboids[k]) {
					for (int i = 0; i < 3; i++) {
						if (dir[i] == 0) continue;
						for (int l = 0; l < 2; l++) {
							float w0 = (connectCuboids[2 * k + l][i] - pos[i]) / dir[i];
							// ray-plane intersection position needs to be closer than the previous best one and further than approximately 0
							bool valid = (w0 > -0.00005 / dirLen && w0 < w);
							if (!valid) break;
							vec3 newPos = pos + w0 * dir;
							for (int j = 1; j < 3; j++) {
								int ij = (i + j) % 3;
								// intersection position also needs to be within other bounds
								if (newPos[ij] < connectCuboids[2 * k][ij] || newPos[ij] > connectCuboids[2 * k + 1][ij]) {
									valid = false;
									break;
								}
							}
							// update normal and ray position
							if (valid) {
								w = w0;
								n = i;
							}
						}
					}
				}
			}
			if (renderMainCuboid) {
			vec3[2] bounds = vec3[2](data.lower, data.upper);
				for (int i = 0; i < 3; i++) {
					if (dir[i] == 0) continue;
					float relevantBound = bounds[dir[i] < 0 ? 1 : 0][i];
					float w0 = (relevantBound - pos[i]) / dir[i];
					if (w0 < -0.00005 / max(dirLen, 0.00001)) {
						relevantBound = bounds[dir[i] < 0 ? 0 : 1][i];
						w0 = (relevantBound - pos[i]) / dir[i];
					}
					vec3 newPos = pos + w0 * dir;
					// ray-plane intersection position needs to be closer than the previous best one and further than approximately 0
					bool valid = (w0 > -0.00005 / dirLen && w0 < w);
					for (int j = 1; j < 3; j++) {
						int ij = (i + j) % 3;
						// intersection position also needs to be within other bounds
						if (newPos[ij] < bounds[0][ij] || newPos[ij] > bounds[1][ij]) {
							valid = false;
							break;
						}
					}
					// update normal and ray position
					if (valid) {
						w = w0;
						n = i;
					}
				}
			}
			return w;
		}
		// returns color data of the block at pos, when hit by ray in direction dir
		vec4 handledata(vxData data, sampler2D atlas, inout vec3 pos, inout vec3 dir, int n) {
			if (!data.crossmodel) {
				if (data.cuboid) {
					float w = aabbIntersect(data, pos, dir, n);
					if (w > 9999) return vec4(0);
					pos += w * dir;
				}
				vec2 spritecoord = vec2(n != 0 ? fract(pos.x) : fract(pos.z), n != 1 ? fract(-pos.y) : fract(pos.z));
				ivec2 texcoord = data.texelcoord - data.spritesize + ivec2(2 * data.spritesize * spritecoord);
				vec4 color = texelFetch(atlas, texcoord, 0);
				if (!data.alphatest) color.a = 1;
				else if (color.a > 0.1 && color.a < 0.9) color.a = min(pow(color.a, TRANSLUCENT_LIGHT_TINT), 0.8);
				// multiply by vertex color for foliage, water etc
				color.rgb *= data.emissive ? vec3(1) : data.lightcol;
				dir = -eye[n] * sign(dir);
				return color;
			}
			// get around floating point errors using an offset
			vec3 offset = 0.001 * eye[n] * sign(dir[n]);
			vec3 blockInnerPos0 = fract(pos + offset) - offset;
			vec3 blockInnerPos = blockInnerPos0 - vec3(data.midcoord.x, 0, data.midcoord.z);;
			// ray-plane intersections
			float w0 = (-blockInnerPos.x - blockInnerPos.z) / (dir.x + dir.z);
			float w1 = (blockInnerPos.x - blockInnerPos.z) / (dir.z - dir.x);
			vec3 p0 = blockInnerPos + w0 * dir + vec3(0.5, 0, 0.5);
			vec3 p1 = blockInnerPos + w1 * dir + vec3(0.5, 0, 0.5);
			bool valid0 = (max(max(abs(p0.x - 0.5), 0.8 * abs(p0.y - 0.5)), abs(p0.z - 0.5)) < 0.4) && w0 > -0.0001;
			bool valid1 = (max(max(abs(p1.x - 0.5), 0.8 * abs(p1.y - 0.5)), abs(p1.z - 0.5)) < 0.4) && w1 > -0.0001;
			vec4 color0 = valid0 ? texelFetch(atlas, ivec2(data.texelcoord + (data.spritesize - 0.5) * (1 - p0.xy * 2)), 0) : vec4(0);
			vec4 color1 = valid1 ? texelFetch(atlas, ivec2(data.texelcoord + (data.spritesize - 0.5) * (1 - p1.xy * 2)), 0) : vec4(0);
			color0.xyz *= data.emissive ? vec3(1) : data.lightcol;
			color1.xyz *= data.emissive ? vec3(1) : data.lightcol;
			valid0 = valid0 && color0.a > 0.1;
			valid1 = valid1 && color1.a > 0.1;
			if (w0 < w1) {
				pos += (valid0 ? w0 : (valid1 ? w1 : 0)) * dir;
				dir = valid0 ?
					-vec3(0.7071, 0, 0.7071) * sign(dot(dir, vec3(1, 0, 1))) :
					(valid1 ? -vec3(0.7071, 0,-0.7071) * sign(dot(dir, vec3(1, 0,-1))) :
						vec3(0)
					);
				// the more distant intersection position only contributes by the amount of light coming through the closer one
				return (vec4(color0.xyz * color0.a, color0.a) + (1 - color0.a) * vec4(color1.xyz * color1.a, color1.a));
			} else {
				pos += (valid1 ? w1 : (valid0 ? w0 : 0)) * dir;
				dir = valid1 ? -vec3(0.7071, 0,-0.7071) * sign(dot(dir, vec3(1, 0,-1))) :
					(valid0 ? -vec3(0.7071, 0, 0.7071) * sign(dot(dir, vec3(1, 0, 1))) :
						vec3(0)
					);
				return (vec4(color1.xyz * color1.a, color1.a) + (1 - color1.a) * vec4(color0.xyz * color0.a, color0.a));
			}
		}

		// voxel ray tracer
		ray_hit_t raytrace(bool lowDetail, vec3 pos0, vec3 dir, sampler2D atlas) {
			ray_hit_t returnVal;
			returnVal.pos = pos0 + dir;
			returnVal.transPos = vec3(-10000);
			returnVal.transColor = vec4(0);
			returnVal.transTriId = -1;
			returnVal.triId = -1;
			vec3 progress;
			for (int i = 0; i < 3; i++) {
				//set starting position in each direction
				progress[i] = dir[i] == 0 ? 10 : (-(dir[i] < 0 ? fract(pos0[i]) : fract(pos0[i]) - 1) / dir[i]);
			}
			int i = 0;
			// get closest starting position
			float w = progress[0];
			for (int i0 = 1; i0 < 3; i0++) {
				if (progress[i0] < w) {
					i = i0;
					w = progress[i];
				}
			}
			// step size in each direction (to keep to the voxel grid)
			vec3 stp = 1 / max(abs(dir), 0.00001);
			float dirlen = max(length(dir), 0.0001);
			float invDirLenScaled = 0.001 / dirlen;
			vec3 dirsgn = sign(dir);
			vec3[3] eyeOffsets;
			for (int k = 0; k < 3; k++) {
				eyeOffsets[k] = 0.0001 * eye[k] * dirsgn[k];
			}
			vec3 pos = pos0 + invDirLenScaled * dir;
			vec3 scatterPos = pos0;
			vec4 rayColor = vec4(0);
			vec4 oldRayColor = vec4(0);
			// check if stuff already needs to be done at starting position
			vxData voxeldata = readVxMap(pos);
			if (lowDetail && voxeldata.full && !voxeldata.alphatest) {
				returnVal.pos = pos;
				returnVal.rayColor = vec4(0, 0, 0, 1);
				return returnVal;
			}
			if (all(greaterThan(pos, -pointerGridSize * POINTER_VOLUME_RES / 2.0)) &&
				all(lessThan(pos, pointerGridSize * POINTER_VOLUME_RES / 2.0)) &&
				voxeldata.trace &&
				!lowDetail
			) {
				returnVal.normal = dir;
				rayColor = handledata(voxeldata, atlas, pos, returnVal.normal, i);
			rayColor.rgb *= rayColor.a;
				if (rayColor.a < 0.1) {
					returnVal.normal = vec3(0);
				}
			}
			if (rayColor.a > 0.1 && rayColor.a < 0.9) {

				returnVal.transPos = pos;
				returnVal.transNormal = returnVal.normal;
			}
			int k = 0; // k is a safety iterator
			int mat = rayColor.a > 0.1 ? voxeldata.mat : 0; // for inner face culling
			vec3 oldPos = pos;
			bool oldFull = voxeldata.full;
			bool wasInRange = false;
			// main loop — cap at 256 (worst diagonal ~117 steps; extra room for transparency chains)
			while (w < 1 && k < 256 && rayColor.a < 0.999) {
				oldRayColor = rayColor;
				pos = pos0 + (min(w, 1.0)) * dir + eyeOffsets[i];
				// read voxel data at new position and update ray colour accordingly
				if (all(greaterThan(pos, -pointerGridSize * POINTER_VOLUME_RES / 2.0)) && all(lessThan(pos, pointerGridSize * POINTER_VOLUME_RES / 2.0))) {
					wasInRange = true;
					voxeldata = readVxMap(pos);
					pos -= eyeOffsets[i];
					if (lowDetail && voxeldata.full && !voxeldata.alphatest) {
						returnVal.pos = pos;
						returnVal.rayColor = vec4(0, 0, 0, 1);
						return returnVal;
					} else {
						if (voxeldata.trace) {
							returnVal.normal = dir;
							vec4 newColor = handledata(voxeldata, atlas, pos, returnVal.normal, i);
							if (dot(pos - pos0, dir) < 0.0) newColor.a = 0;
							bool samemat = voxeldata.mat == mat;
							mat = 0;
							if (newColor.a > 0.1) {
								mat = voxeldata.mat;
							} else {
								returnVal.normal = vec3(0);
							}
							if (samemat) newColor.a = clamp(10.0 * newColor.a - 9.0, 0.0, 1.0);
							rayColor.rgb += (1 - rayColor.a) * newColor.a * newColor.rgb;
							rayColor.a += (1 - rayColor.a) * newColor.a;
							if (oldRayColor.a < 0.1 && rayColor.a > 0.1 && rayColor.a < 0.9) {
								returnVal.transPos = pos;
								returnVal.transNormal = returnVal.normal;
							}
						}
					}
					#if CAVE_SUNLIGHT_FIX > 0
					if (!all(greaterThan(pos, -pointerGridSize * POINTER_VOLUME_RES / 2.0 + 2)) && all(lessThan(pos, pointerGridSize * POINTER_VOLUME_RES / 2.0 - 2))) {
						int height0 = -100; //TODO: get the actual height
						if (pos.y < height0) {
							rayColor.a = 1;
						}
					}
					#endif
					pos += eyeOffsets[i];
				}
				else {
					if (wasInRange) break;
				}
				// advance DDA — branchless min-axis selection (#6)
				progress[i] += stp[i];
				// find the axis with smallest progress value, branchlessly
				bvec3 bsel = lessThan(progress, min(progress.yzx, progress.zxy));
				i = bsel.x ? 0 : (bsel.y ? 1 : 2);
				w = progress[i];
				k++;
			}
			float oldAlpha = rayColor.a;
			rayColor.a = 1 - exp(-4*length(scatterPos - pos0)) * (1 - rayColor.a);
			rayColor.rgb += rayColor.a - oldAlpha; 
			pos0 = pos;
			#ifdef DEBUG_OVERDRAW
				// Debug-only: paint overdraw rays bright red so they are visible in dev builds
				if (k >= 256) {
					oldRayColor = vec4(1, 0, 0, 1);
					rayColor    = vec4(1, 0, 0, 1);
				}
			#else
				// Production: treat overdraw as an opaque hit rather than bleeding red
				if (k >= 256) rayColor.a = 1.0;
			#endif
			returnVal.rayColor = rayColor;
			returnVal.transColor = oldRayColor;
			returnVal.pos = pos;
			return returnVal;
		}

		ray_hit_t raytrace(vec3 pos0, vec3 dir, sampler2D atlas) {
			return raytrace(false, pos0, dir, atlas);
		}
	#endif
	bool isInBounds(vec3 v, vec3 lower, vec3 upper) {
		if (v == clamp(v, lower, upper)) return true;
		return false;
	}

	float getNiceness(mat3 A) {
		return abs(A[0][0] * A[1][1] * A[2][2]);
	}

	vec3 linSolve(mat3 A, vec3 b) {
		// No transpose needed: GLSL mat3 is column-major, A[col][row].
		// Gaussian elimination treats rows as A[col][row], cols as A[row].
		// We iterate over pivots by row (outer i), eliminate rows below (inner j).
		// Removing the old transpose() saves 9 unnecessary assignments per call. (#17)
		for (int i = 0; i < 2; i++) {
			// Partial pivoting: find max |A[i][j]| for j > i
			for (int j = i + 1; j < 3; j++) {
				if (abs(A[i][j]) > abs(A[i][i])) {
					// Swap rows i and j (swap columns i and j in transposed sense)
					vec3 tmp = vec3(A[0][i], A[1][i], A[2][i]);
					A[0][i] = A[0][j]; A[1][i] = A[1][j]; A[2][i] = A[2][j];
					A[0][j] = tmp.x;   A[1][j] = tmp.y;   A[2][j] = tmp.z;
					float tmp2 = b[i]; b[i] = b[j]; b[j] = tmp2;
				}
			}
			for (int j = i + 1; j < 3; j++) {
				float t = A[i][j] / A[i][i];
				A[0][j] -= t * A[0][i];
				A[1][j] -= t * A[1][i];
				A[2][j] -= t * A[2][i];
				b[j]    -= t * b[i];
			}
		}
		for (int j = 1; j >= 0; j--) {
			for (int i = j + 1; i < 3; i++) {
				float t = A[i][j] / A[i][i];
				A[i][j] = 0.0;
				b[j] -= t * b[i];
			}
		}
		return vec3(
			b[0] / A[0][0],
			b[1] / A[1][1],
			b[2] / A[2][2]
		);
	}

	vec3 rayTriangleIntersect(vec3 pos0, vec3 dir, tri_t triangle) {
		mat3 solveMat = mat3(triangle.pos[1] - triangle.pos[0], triangle.pos[2] - triangle.pos[0], -dir);
		vec3 solveVec = pos0 - triangle.pos[0];
		vec3 solution = linSolve(solveMat, solveVec);
		if (min(solution.x, solution.y) < 0 || (solution.x + solution.y) > 1) return vec3(-1);
		return solution;
	}

	vec2 boundsIntersect(vec3 pos0, vec3 dir, vec3 lower0, vec3 upper0) {
		vec3 dirsgn = vec3(greaterThan(dir, vec3(0))) * 2.0 - 1.0;
		dir = abs(dir);
		dir += 0.0001 * (1 - sign(dir));
		lower0 -= pos0;
		upper0 -= pos0;
		lower0 *= dirsgn;
		upper0 *= dirsgn;
		vec3 lower = min(lower0, upper0);
		vec3 upper = max(lower0, upper0);
		float w0 = -100000.0;
		float w1 =  100000.0;
		for (int i = 0; i < 3; i++) {
			w0 = max(w0, lower[i] / dir[i]);
			w1 = min(w1, upper[i] / dir[i]);
		}
		if (w0 <= w1) return vec2(w0, w1);
		return vec2(1, -1);
	}

	vec2 boundsIntersect(vec3 pos0, vec3 dir, tri_t triangle) {
		vec3 lower0 = min(min(triangle.pos[0], triangle.pos[1]), triangle.pos[2]);
		vec3 upper0 = max(max(triangle.pos[0], triangle.pos[1]), triangle.pos[2]);
		return boundsIntersect(pos0, dir, lower0, upper0);
	}
	#ifdef ACCURATE_RT
		ray_hit_t betterRayTrace(vec3 pos0, vec3 dir, sampler2D atlas, bool backFaceCulling) {
			pos0 *= 1.0 / POINTER_VOLUME_RES;
			dir *= 1.0 / POINTER_VOLUME_RES;

			ray_hit_t returnVal;

			returnVal.transColor = vec4(0);
			returnVal.transPos = vec3(-10000);
			returnVal.transTriId = -1;

			vec3 progress;
			for (int i = 0; i < 3; i++) {
				//set starting position in each direction
				progress[i] = -(dir[i] < 0 ? fract(pos0[i]) : fract(pos0[i]) - 1) / dir[i];
			}
			// step size in each direction (to keep to the voxel grid)
			vec3 stp = abs(1 / dir);
			float dirlen = length(dir);
			float invDirLenScaled = 0.001 / dirlen;
			int i = 0;
			float istp = stp[0];
			for (int j = 1; j < 3; j++) {
				if (stp[j] < istp) {
					istp = stp[j];
					i = j;
				}
			}
			float w = invDirLenScaled;
			progress[i] -= stp[i];
			vec3 dirsgn = sign(dir);
			vec3[3] eyeOffsets;
			for (int k = 0; k < 3; k++) {
				eyeOffsets[k] = 0.0001 * eye[k] * dirsgn[k];
			}
			int k = 0; // k is a safety iterator
			vec3 oldPos = pos0;
			bool oldFull = false;
			bool wasInRange = false;
			vec3 pos;
			vec4 rayColor = vec4(0);
			int hitID = -1;
			float hitW = 1;
			float transHitW = 1;
			for (;w < 1 && k < 200 && rayColor.a < 0.999; k++) {
				pos = pos0 + w * dir + eyeOffsets[i];
				if (isInBounds(pos, -pointerGridSize / 2, pointerGridSize / 2)) {
					wasInRange = true;
					ivec3 coords = ivec3(pos + pointerGridSize / 2);
					int triLocHere = readVolumePointer(coords, 1);
					int triCountHere = readTriPointer(triLocHere) - 1;
					while (triCountHere > 0) {
						int packedBounds = readVolumePointer(coords, 2);
						vec3 lowerBound = vec3(
							packedBounds % 32,
							(packedBounds >> 5) % 32,
							(packedBounds >> 10) % 32
						) / 31.0;
						vec3 upperBound = vec3(
							(packedBounds >> 15) % 32,
							(packedBounds >> 20) % 32,
							(packedBounds >> 25) % 32
						) / 31.0;
						vec3 lowerBound0 = lowerBound;
						vec3 upperBound0 = upperBound;
						lowerBound += coords - pointerGridSize / 2;
						upperBound += coords - pointerGridSize / 2;
						vec2 vxBoundIsct = boundsIntersect(pos0, dir, lowerBound, upperBound);
						if (vxBoundIsct.y <= 0 || vxBoundIsct.x > hitW) break;

						for (int j = 1; j <= triCountHere; j++) {
							int thisTriId = readTriPointer(triLocHere + j);
							if (thisTriId == 0) rayColor.r += 0.1;
							tri_t thisTri = tris[thisTriId];
							vec3 cnormal = cross(thisTri.pos[0] - thisTri.pos[1], thisTri.pos[0] - thisTri.pos[2]);
							if (backFaceCulling && dot(cnormal, dir) >= 0) continue;
							vec2 boundWs = boundsIntersect(POINTER_VOLUME_RES * pos0, POINTER_VOLUME_RES * dir, thisTri);
							if (boundWs.y <= 0 || boundWs.x > hitW) continue;
							vec3 hitPos = rayTriangleIntersect(POINTER_VOLUME_RES * pos0, POINTER_VOLUME_RES * dir, thisTri);
							if (hitPos.z <= 0 || hitPos.z > hitW) continue;
							ivec2 coord0 = ivec2(thisTri.texCoord[0] % 65536, thisTri.texCoord[0] / 65536);
							vec2 coord = coord0;
							vec2 offsetDir = vec2(0);
							for (int i = 0; i < 2; i++) {
								ivec2 coord1 = ivec2(thisTri.texCoord[i+1] % 65536, thisTri.texCoord[i+1] / 65536);
								vec2 dcoord = coord1 - coord0;
								dcoord += sign(dcoord);
								coord += vec2(hitPos[i] * dcoord);
								offsetDir += sign(dcoord) * (1 - abs(offsetDir));
							}
							coord -= 0.5 * offsetDir;
							vec4 newColor = ((thisTri.matBools >> 16) % 2 == 0) ? texelFetch(atlas, ivec2(coord + 0.5), 0) : vec4(1);
							if (newColor.a < 0.1) continue;
							vec4 vertexCol0 = vec4(
									thisTri.vertexCol[0] % 256,
								(thisTri.vertexCol[0] >>  8) % 256,
								(thisTri.vertexCol[0] >> 16) % 256,
								(thisTri.vertexCol[0] >> 24) % 256
							);
							vec4 vertexCol = vertexCol0;
							for (int i = 0; i < 2; i++) {
								vec4 vertexCol1 = vec4(
										thisTri.vertexCol[i+1] % 256,
									(thisTri.vertexCol[i+1] >>  8) % 256,
									(thisTri.vertexCol[i+1] >> 16) % 256,
									(thisTri.vertexCol[i+1] >> 24) % 256
								);
								vertexCol += hitPos[i] * (vertexCol1 - vertexCol0);
							}
							newColor *= vertexCol / 255.0;
							if (transHitW < hitPos.z) rayColor += (1 - rayColor.a) * newColor * vec2(1, newColor.a).yyyx;
							else           rayColor = newColor +  (1 - newColor.a) * rayColor * vec2(1, rayColor.a).yyyx;
							if (newColor.a > 0.9) {
								if (hitPos.z < hitW) {
									hitW = hitPos.z;
									returnVal.pos = pos0 + hitPos.z * dir;
									returnVal.normal = normalize(cnormal);
									returnVal.triId = thisTriId;
								}
							} else if (hitPos.z < transHitW) {
								transHitW = hitPos.z;
								returnVal.transPos = pos0 + hitPos.z * dir;
								returnVal.transTriId = thisTriId;
								returnVal.transNormal = normalize(cnormal);
								returnVal.transColor = newColor;
							}
						}
						break;
					}
				} else if (wasInRange) break;
				// advance DDA — branchless min-axis selection (#6)
				progress[i] += stp[i];
				bvec3 bsel = lessThan(progress, min(progress.yzx, progress.zxy));
				i = bsel.x ? 0 : (bsel.y ? 1 : 2);
				w = progress[i];
			}
			if (rayColor.a < 0.999) {
				returnVal.pos = pos0 + dir;
			}
			returnVal.rayColor = rayColor;
			returnVal.pos *= POINTER_VOLUME_RES;
			returnVal.transPos *= POINTER_VOLUME_RES;
			return returnVal;
		}

		ray_hit_t betterRayTrace(vec3 pos0, vec3 dir, sampler2D atlas) {
			return betterRayTrace(pos0, dir, atlas, true);
		}
	#endif

#endif