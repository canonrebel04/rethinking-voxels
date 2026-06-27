#include "/lib/common.glsl"

uniform float viewWidth;
uniform float viewHeight;
ivec2 view = ivec2(viewWidth + 0.1, viewHeight + 0.1);
ivec2 lowResView = view / 8;
uniform int frameCounter;
uniform int isEyeInWater;
uniform int heldItemId;
uniform int heldItemId2;
uniform vec3 eyePosition;
uniform vec3 cameraPosition;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D colortex1;
uniform sampler2D colortex3;
uniform sampler2D colortex8;
uniform sampler2D colortex15;

#include "/lib/vx/SSBOs.glsl"
#include "/lib/vx/raytrace.glsl"
const ivec2[4] offsets = ivec2[4](
	ivec2(0, 0),
	ivec2(1, 0),
	ivec2(1, 1),
	ivec2(0, 1)
);
void main() {
	#ifdef PER_BLOCK_LIGHT
		return;
	#endif
	ivec2 coords = ivec2(gl_FragCoord.xy);
	float oneMinusDepth = texelFetch(colortex8, coords, 0).a;
	ivec2 localCoords = coords * 2 + offsets[frameCounter % 4];
	vec3 lightCol = vec3(0);
	if (all(lessThan(localCoords, view))) {

		vec4 normalDepthData = texelFetch(colortex8, localCoords, 0);
		vec4 materialData = texelFetch(colortex1, localCoords, 0);
		if (length(normalDepthData.xyz) > 0.5) {
			vec4 pos = vec4(localCoords, 1 - normalDepthData.w, 1);
			pos.xy = (pos.xy + 0.5) / view;
			pos.xyz = 2 * pos.xyz - 1;
			pos = gbufferModelViewInverse * (gbufferProjectionInverse * pos);
			pos.xyz = pos.xyz / pos.w;
			vec3 normPlayerPos = normalize(pos.xyz);
			pos.xyz = pos.xyz + 8.0 * fract(0.125 * cameraPosition);
			float posLen = length(pos);
			pos.xyz += max(0.05, 0.01 * posLen) * normalDepthData.xyz;
			if (clamp(pos.xyz, -pointerGridSize * POINTER_VOLUME_RES / 2.0, pointerGridSize * POINTER_VOLUME_RES / 2.0) == pos.xyz) {
				ivec3 pgc = ivec3(pos.xyz / POINTER_VOLUME_RES + pointerGridSize / 2.0) / 4; // pointer grid coord
				int lightCount = min(readVolumePointer(pgc, 4), 64);
				#if HELD_LIGHTING_MODE > 0
					lightCount = min(lightCount + 2, 64);
				#endif
				int lightStripLoc = readVolumePointer(pgc, 5) + 1;
				ivec2 roughCoords = min(localCoords / 8, lowResView - 1);
				for (int lightNum = 0; lightNum < lightCount; lightNum++) {
					#if HELD_LIGHTING_MODE > 0
						int lightNum1 = lightNum < lightCount - 2 ? lightNum : 64 + lightNum - lightCount;
					#else
						#define lightNum1 lightNum
					#endif
					ivec2 tileCoords = ivec2(lightNum1 % 8, lightNum1 / 8);
					float visible = texelFetch(colortex3, lowResView * tileCoords + roughCoords, 0).x;
					if (visible < 0.01) continue;
					light_t thisLight;
					#if HELD_LIGHTING_MODE > 0
						if (lightNum1 < 62)
					#endif
						thisLight = lights[readLightPointer(lightStripLoc + lightNum)];
					#if HELD_LIGHTING_MODE > 0
						else {
							int itemId = lightNum1 == 62 ? heldItemId : heldItemId2;
							if (itemId <= 0 || itemId > 9999) {
								materialData.a = 1.0;
								thisLight.pos = pos.xyz - normalDepthData.xyz;
							} else {
								vec3 bodyRelPos =
									-gbufferModelViewInverse[0].xyz * (lightNum1 - 62.5) -
									0.5 * vec3(
										normalize(
											gbufferModelViewInverse[2].xz -
											gbufferModelViewInverse[2].y * gbufferModelViewInverse[1].xz
										), 0).xzy -
									vec3(0, 0.5, 0);
								thisLight.pos = bodyRelPos + eyePosition - 8 * floor(0.125 * cameraPosition);
								#ifdef CORECT_CUBOID_OFFSETS
									thisLight.size = vec3(0.1);
								#else
									thisLight.size = vec3(BLOCKLIGHT_SOURCE_SIZE * 0.5);
								#endif
								thisLight.brightnessMat = (10 * HELD_LIGHTING_MODE) << 16;
								thisLight.packedColor = itemId % 16 * 16 + ((itemId >> 4) % 16 << 12) + ((itemId >> 8) % 16 << 20);
							}
						}
					#endif
					vec3 dir = thisLight.pos - pos.xyz;
					vec3 normDir = normalize(dir);
					vec3 offset = hash33(vec3(localCoords, frameCounter)) * 1.98 - 0.99;
					offset *= thisLight.size;
					vec3 sssOffset = vec3(0);
					float sssBrightness = 0;
					if (materialData.a < 0.75) {
						sssOffset = max(posLen * 0.03, 0.3) * normDir;
						float VdotL = max(0, dot(normPlayerPos, normDir));
						float lightFactor = pow(max(VdotL, 0.0), 10.0) * float(isEyeInWater == 0);
						if (abs(materialData.a - 0.5) < 0.25) {
							sssBrightness = lightFactor * 0.5 + 0.3;
						} else {
							sssBrightness = lightFactor * 0.6;
						}
					}

					float ndotl = sqrt(max(0, dot(normDir, normalDepthData.xyz)));

					float brightness = length(dir);
					float lightBrightness = thisLight.brightnessMat >> 16;
					// ⚡ Bolt: Use explicit multiplication instead of pow(x, 2) for performance and safety
					float temp = max(0.0, 1.0 - brightness / lightBrightness);
					brightness = max(ndotl, sssBrightness) * 0.0625 * lightBrightness * (temp * temp);
					if (brightness > 0.01) {
						vec3 thisLightColor = vec3(
							thisLight.packedColor % 256,
							(thisLight.packedColor >> 8) % 256,
							(thisLight.packedColor >> 16) % 256
						) / 255.0 * brightness;
						if (visible < 0.99) {
							#ifdef ACCURATE_RT
								ray_hit_t rayHit = betterRayTrace(pos.xyz + sssOffset, dir + offset - sssOffset, colortex15, false);
							#else
								ray_hit_t rayHit = raytrace(pos.xyz + sssOffset, dir + offset - sssOffset, colortex15);
							#endif
							vec3 dist = abs(thisLight.pos - rayHit.pos) / (max(thisLight.size, vec3(0.5)) + 0.01);
							if (rayHit.rayColor.a < 0.9) dist = vec3(0);
							if (max(max(dist.x, dist.y), dist.z) < 1.0) {
								rayHit.transColor.rgb = rayHit.transColor.a < 0.1 ? vec3(1.0) : rayHit.transColor.rgb;
								float rayBrightness = max(max(
									rayHit.transColor.r,
									rayHit.transColor.g),
									rayHit.transColor.b
								);
								rayHit.transColor.rgb /= sqrt(rayBrightness);
								rayHit.transColor.rgb *= clamp(4 - 4 * rayHit.transColor.a, 0, 1);
								thisLightColor *= rayHit.transColor.rgb;
							} else thisLightColor = vec3(0);
						}
						lightCol += thisLightColor;
					}
				}
			}
		}
	}
	/*RENDERTARGETS:8*/
	float lightColBrightness = max(max(lightCol.x, lightCol.y), max(lightCol.z, 0.000000001));
	gl_FragData[0] = vec4(lightCol / lightColBrightness * log(lightColBrightness * 0.4 + 1), oneMinusDepth);
}