#ifndef IRRADIANCECACHE
    #include "/lib/vx/irradianceCache.glsl"
#endif

vec3 GetColoredLightFog(vec3 nPlayerPos, vec3 translucentMult, float lViewPos, float lViewPos1, float dither, out vec3 transmittance) {
    transmittance = vec3(1.0);
    vec3 lightFog = vec3(0.0);

    float maxDist = min(voxelVolumeSize.x * 0.5 - 1.0, min(far, 96.0));
    float rayMax = min(lViewPos1, maxDist);
    float rayMin = 0.35;
    if (rayMax <= rayMin) return vec3(0.0);

    vec3 fractCamPos = cameraPositionInt.y == -98257195 ? fract(cameraPosition) : cameraPositionFract;

    // Atmospheric medium scattering and absorption coefficients
    float sigma_s_base = 0.022 * VBL_STRENGTH;
    vec3 sigma_a = vec3(0.002);

    #ifdef OVERWORLD
        sigma_s_base *= mix(0.7, 1.85, rainFactor);
        #ifdef SPECIAL_BIOME_WEATHER
            sigma_s_base *= 1.0 + 0.5 * inDry * rainFactor;
        #endif
    #elif defined NETHER
        sigma_s_base *= 2.5 * VBL_NETHER_MULT;
        sigma_a = max(vec3(0.005), (vec3(1.0) - netherColor * 1.5) * 0.035);
    #elif defined END
        sigma_s_base *= 0.65 * VBL_END_MULT;
        sigma_a = vec3(0.004, 0.002, 0.006);
    #endif

    if (isEyeInWater == 1) {
        sigma_s_base = 0.085;
        sigma_a = vec3(0.18, 0.055, 0.015); // Physical underwater wavelength absorption (Beer-Lambert)
    }

    float sigma_s = sigma_s_base;
    vec3 sigma_t = vec3(sigma_s) + sigma_a;

    #ifndef VBL_SAMPLES
        #define VBL_SAMPLES 16
    #endif
    const int SAMPLES = VBL_SAMPLES;
    const float power = 1.8;
    const float g = 0.45;
    const float g2 = g * g;

    for (int i = 0; i < SAMPLES; i++) {
        float u = (float(i) + dither) / float(SAMPLES);
        float t = rayMin + (rayMax - rayMin) * pow(u, power);

        float uPrev = max(0.0, (float(i) - 0.5 + dither) / float(SAMPLES));
        float uNext = min(1.0, (float(i) + 0.5 + dither) / float(SAMPLES));
        float dt = (rayMax - rayMin) * (pow(uNext, power) - pow(uPrev, power));

        vec3 p = nPlayerPos * t;
        if (any(greaterThan(abs(p * 2.0), vec3(voxelVolumeSize)))) break;

        vec3 voxelPos = p + fractCamPos;
        vec3 dominantDir;
        vec3 lightSample = readVolumetricBlocklight(voxelPos, dominantDir);

        if (dot(lightSample, lightSample) > 0.0001) {
            float phase = 1.0;
            float dLen = length(dominantDir);
            if (dLen > 0.001) {
                float cosTheta = clamp(dot(nPlayerPos, -dominantDir / dLen), -1.0, 1.0);
                float hg = (1.0 - g2) / pow(max(0.01, 1.0 + g2 - 2.0 * g * cosTheta), 1.5);
                float lum = dot(lightSample, vec3(0.2126, 0.7152, 0.0722));
                float anisotropy = clamp(dLen / (lum + 0.001), 0.0, 1.0);
                phase = mix(1.0, hg, anisotropy * 0.7);
            }

            // Radial distance fade towards edge of voxel volume to avoid clipping seams
            float distEdge = max0(1.0 - length(p) / maxDist);
            lightSample *= distEdge;

            if (t > lViewPos) lightSample *= translucentMult;

            vec3 stepTau = sigma_t * dt;
            vec3 stepTransmittance = exp(-stepTau);
            vec3 stepInscatter = lightSample * (phase * sigma_s) * (vec3(1.0) - stepTransmittance) / max(vec3(1e-5), sigma_t);

            lightFog += stepInscatter * transmittance;
            transmittance *= stepTransmittance;
        } else {
            vec3 stepTau = sigma_t * dt;
            transmittance *= exp(-stepTau);
        }

        if (max(transmittance.r, max(transmittance.g, transmittance.b)) < 0.01) break;
    }

    #ifdef NETHER
        lightFog *= netherColor * 2.0 * VBL_NETHER_MULT;
    #elif defined END
        lightFog *= VBL_END_MULT;
    #endif

    lightFog *= 1.0 - maxBlindnessDarkness;

    return lightFog;
}

vec3 GetColoredLightFog(vec3 nPlayerPos, vec3 translucentMult, float lViewPos, float lViewPos1, float dither) {
    vec3 dummyTransmittance;
    return GetColoredLightFog(nPlayerPos, translucentMult, lViewPos, lViewPos1, dither, dummyTransmittance);
}
