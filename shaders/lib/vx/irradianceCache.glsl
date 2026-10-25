#ifndef IRRADIANCECACHE
#define IRRADIANCECACHE
bool isInRange(vec3 vxPos) {
    return all(greaterThan(vxPos, -0.5*voxelVolumeSize)) && all(lessThan(vxPos, 0.5*voxelVolumeSize));
}

uniform sampler3D irradianceCache;
#ifdef DIRECTIONAL_GI
    uniform sampler3D irradianceDirCache;
#endif

vec3 readIrradianceCache(vec3 vxPos, vec3 normal) {
    if (!isInRange(vxPos)) return vec3(0);
    vec3 sampleCoord = clamp((vxPos + 0.5 * normal) / voxelVolumeSize + 0.5, vec3(0.0), vec3(1.0));
    vec3 vxPosScaled = sampleCoord * vec3(1.0, 0.5, 1.0);
    vec4 color = textureLod(irradianceCache, vxPosScaled, 0);
    vec3 dcRadiance = color.rgb / max(color.a, 0.0001);

    #ifdef DIRECTIONAL_GI
        vec4 dirData = textureLod(irradianceDirCache, sampleCoord, 0);
        vec3 D = dirData.xyz / max(dirData.w, 0.0001);
        float dLen = length(D);
        if (dLen > 0.0001) {
            float dcLum = dot(dcRadiance, vec3(0.2126, 0.7152, 0.0722));
            float anisotropy = clamp(dLen / (dcLum + 0.001), 0.0, 1.0);
            vec3 dominantDir = D / dLen;
            vec3 worldNormal = length(normal) > 0.001 ? normalize(normal) : vec3(0.0, 1.0, 0.0);
            float NdotL = dot(worldNormal, dominantDir);
            float directionalFactor = mix(1.0, clamp(NdotL * 0.85 + 0.85, 0.15, 1.85), anisotropy);
            return dcRadiance * directionalFactor;
        }
    #endif

    return dcRadiance;
}

vec3 readSurfaceVoxelBlocklight(vec3 vxPos, vec3 normal) {
    if (!isInRange(vxPos)) return vec3(0);
    vxPos = ((vxPos + 0.5 * normal) / voxelVolumeSize + vec3(0.5, 1.5, 0.5)) * vec3(1.0, 0.5, 1.0);
    vec4 color = textureLod(irradianceCache, vxPos, 0);
    float lColor = length(color.rgb);
    if (lColor > 0.01) color.rgb *= log(lColor + 1) / lColor;
    return color.rgb;
}

vec3 readVolumetricBlocklight(vec3 vxPos, out vec3 dominantDir) {
    dominantDir = vec3(0.0);
    if (!isInRange(vxPos)) return vec3(0.0);
    vec3 normPos = vxPos / voxelVolumeSize + 0.5;
    vec3 sampleCoord = (normPos + vec3(0.0, 1.0, 0.0)) * vec3(1.0, 0.5, 1.0);
    vec4 color = textureLod(irradianceCache, sampleCoord, 0);
    vec3 radiance = color.rgb / max(color.a, 0.0001);
    #ifdef DIRECTIONAL_GI
        vec4 dirData = textureLod(irradianceDirCache, normPos, 0);
        dominantDir = dirData.xyz;
    #endif
    return radiance;
}

vec3 readVolumetricBlocklight(vec3 vxPos) {
    vec3 unusedDir;
    return readVolumetricBlocklight(vxPos, unusedDir);
}
#endif