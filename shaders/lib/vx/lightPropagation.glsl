int propagates(vxData blockData, inout vec3 colMult) {
	int propval;
	vec4 texCol = vec4(1);
	if (blockData.alphatest) {
		vec4 texCol0[3] = vec4[3](
			texture2DLod(colortex15, blockData.texcoord, 0),
			texture2DLod(colortex15, blockData.texcoord, 1),
			texture2DLod(colortex15, blockData.texcoord, 3)
		);
		for (int i = 0; i < 3; i++) if (texCol0[i].a < texCol.a) texCol = texCol0[i];
	}
	if (blockData.emissive || !blockData.trace || blockData.crossmodel || texCol.a < 0.2) propval = 127;
	else if (texCol.a < 0.8) {
		propval = 127;
		texCol.a = pow(texCol.a, TRANSLUCENT_LIGHT_TINT);
		texCol.rgb /= max(max(0.0001, texCol.r), max(texCol.g, texCol.b));
		texCol.rgb *= 0.5 + TRANSLUCENT_LIGHT_CONDUCTION / (texCol.r + texCol.g + texCol.b);
		colMult = clamp(1 - texCol.a + texCol.a * texCol.rgb, vec3(0), vec3(max(1.0, TRANSLUCENT_LIGHT_CONDUCTION + 0.02)));
	}
	else if (blockData.full) propval = 0;
	else if (blockData.cuboid) {
		propval = 0;
		// Explicit 6-face enumeration: lower face (bit 0-2) then upper face (bit 3-5).
		// axis: 0=X, 1=Y, 2=Z. side: 0=lower, 1=upper.
		// Bit k is set if face k is open (light can pass through).
		// Replaces the original modulo-arithmetic loop which was hard to verify. (#13)
		for (int k = 0; k < 6; k++) {
			int axis = k % 3;
			bool isUpper = (k >= 3);
			float bound = isUpper ? blockData.upper[axis] : blockData.lower[axis];
			bool faceTouching = isUpper ? (bound > 0.98) : (bound < 0.02);
			if (!faceTouching) {
				// Face doesn't reach the block boundary — light passes freely through it
				propval += (1 << k);
				continue;
			}
			// Face touches boundary: check the two perpendicular axes seal the face
			bool seals = true;
			int a1 = (axis + 1) % 3;
			int a2 = (axis + 2) % 3;
			if (blockData.lower[a1] > 0.02 || blockData.upper[a1] < 0.98) seals = false;
			if (blockData.lower[a2] > 0.02 || blockData.upper[a2] < 0.98) seals = false;
			if (!seals) propval += (1 << k);
		}
	} else propval = 127;
	return propval;
}
int propagates(vxData blockData) {
	vec3 colMult;
	return propagates(blockData, colMult);
}