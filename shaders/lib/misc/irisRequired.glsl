// Made by Balint for Iris 1.6.
// You are free to include this in any pack, as long as this notice is not removed.

uniform float frameTimeCounter;
uniform float viewWidth;
uniform float viewHeight;

const vec3 SPACE_COLOR = vec3(0.07, 0.27, 0.46);
const vec2 SPACE_SPEED = vec2(0.5, 0.0);
const vec2 STAR_CELL_SIZE = vec2(0.1);
const float STAR_PERCENTAGE = 0.1;
const float STAR_SHINE_SPEED = 4.0; // State changes per second
const int STAR_STATES = 6;
const int[] STARS = int[](1, 18, 278, 4365, 5128, 4104);

const float PIXEL_SIZE = 0.007;
const float RAINBOW_WAVE_SPEED = 2.0;
const float WAVE_PIXEL_LENGTH = 10.0;
const vec3[] RAINBOW = vec3[](
    vec3(0.47, 0.27, 1),
    vec3(0.07, 0.67, 1),
    vec3(0.25, 1, 0.05),
    vec3(1, 1, 0.02),
    vec3(1, 0.65, 0.05),
    vec3(1, 0.07, 0.07)
);

const float LOGO_SIZE = 0.35;
const vec3[] LOGO_COLORS = vec3[](
    vec3(0.9, 0.23, 0.23),
    vec3(0.97, 0.41, 0.11),
    vec3(0.95, 0.48, 0.29),
    vec3(0.96, 0.75, 0.16),
    vec3(0.97, 0.71, 0.33),
    vec3(0.56, 0.85, 0.4),
    vec3(0.11, 0.73, 0.44),
    vec3(0.05, 0.68, 0.6),
    vec3(0.18, 0.87, 0.71),
    vec3(0.55, 0.96, 0.87),
    vec3(0.3, 0.39, 0.69),
    vec3(0.3, 0.6, 0.89),
    vec3(0.55, 0.82, 0.98),
    vec3(0.65, 0.51, 0.94),
    vec3(0.91, 0.67, 0.92),
    vec3(0.92, 0.49, 0.59)
);

const float PI = 3.141592654;
#include "/lib/util/textRendering.glsl"


// https://www.shadertoy.com/view/4tXyWN
uint hash(uvec2 x) {
uvec2 q = 1103515245U * ((x >> 1U) ^ x.yx);
uint n = 1103515245U * (q.x ^ (q.y >> 3U));
return n;
}

// https://github.com/riccardoscalco/glsl-pcg-prng
uint pcg(inout uint state) {
uint newState = state * uint(747796405) + uint(2891336453);
uint word = ((newState >> ((newState >> uint(28)) + uint(4))) ^ newState) * uint(277803737);
state = (word >> uint(22)) ^ word;
return state;
}

float rand(inout uint state) {
return float(pcg(state)) / float(uint(0xffffffff));
}

void drawStars(ivec2 cellIndex, vec2 cellUV, inout vec3 color) {
uint state = hash(uvec2(cellIndex));
if (rand(state) > STAR_PERCENTAGE) {
// Not a star
return;
}

cellUV = (cellUV - 0.5) * 1.5 + 0.5;
if (clamp(cellUV, 0.0, 1.0) != cellUV)
return;

float direction = rand(state) < 0.5 ? -1.0 : 1.0;
float offset = rand(state) * float(STAR_STATES);
int starState = (int(floor(offset + frameTimeCounter * STAR_SHINE_SPEED * direction)) % STAR_STATES + STAR_STATES) % STAR_STATES;

ivec2 pixel = abs(ivec2(cellUV * 7.0) - ivec2(3));
int pixelIndex = pixel.y * 4 + pixel.x;
int on = (STARS[starState] >> pixelIndex) & 1;
if (on == 0)
return;

color = vec3(0.4, 0.6, 0.9);
}

void drawRainbow(vec2 uv, inout vec3 color) {
if (uv.x > 0.5)
return;

uv.y -= viewHeight / viewWidth / 2.0; // Center
uv = floor(uv / PIXEL_SIZE);
float timeOffset = floor(frameTimeCounter * RAINBOW_WAVE_SPEED * 2.0);
uv.y += floor(mod(timeOffset + uv.x / WAVE_PIXEL_LENGTH, 2.0)) + 9.0; // Wave
if (clamp(uv.y, 0.0, 18.0) != uv.y)
return;

int colorIndex = int(floor(uv.y / 3.0));

color = RAINBOW[colorIndex];
}

void drawLogo(vec2 uv, inout vec3 color) {
vec2 aspect = vec2(viewWidth, viewHeight) / viewWidth;
uv = (uv - aspect / 2.0) / LOGO_SIZE + 0.5;
uv.x -= 0.3;
if (clamp(uv, 0.0, 1.0) != uv)
return;

uv = floor(uv / PIXEL_SIZE / 3.0) * PIXEL_SIZE * 3.0;

uv -= 0.5;
float len = length(uv);
float angle = atan(uv.y, uv.x) - PI + frameTimeCounter;
float leafIndex = angle / 2.0 / PI * 16.0;
float func = abs(fract(leafIndex) - 0.5);

float outerRadius = (1.0 - pow(func, 0.8)) * 0.15 + 0.35;
if (len > outerRadius)
return;

float innerRadius = pow(func, 1.2) * 0.08 + 0.18;
if (len < innerRadius)
return;

float t_len = (len - 0.35) / 0.5;
int colorIndex = int(floor(fract(angle / 2.0 / PI - (t_len * t_len) * 0.3) * 16.0)); // ⚡ Bolt: Replace pow(x, 2.0) with explicit multiplication

color = LOGO_COLORS[colorIndex];
if (len > outerRadius - 0.05)
color *= 0.8;
}

void main() {
vec2 uv = gl_FragCoord.xy / viewWidth;

vec2 starUV = (uv + frameTimeCounter * SPACE_SPEED) / STAR_CELL_SIZE;
ivec2 cellIndex = ivec2(floor(starUV));
vec2 cellUV = fract(starUV);

vec3 color = SPACE_COLOR;
float pixelSize = viewWidth / 200.0;
vec2 coord = gl_FragCoord.xy / pixelSize;
drawStars(cellIndex, cellUV, color);
drawRainbow(uv, color);
drawLogo(uv, color);

#if MC_VERSION < 11802
    beginText(ivec2(coord), ivec2(viewWidth / pixelSize / 2.0 - 13.0 * 7.0, 24.0));
text.bgCol = vec4(0.0);
text.fgCol = vec4(LOGO_COLORS[int(coord.x / 6.0 + frameTimeCounter * 4.0) % 16], 1.0);
printString((_U, _p, _g, _r, _a, _d, _e, _space, _M, _i, _n, _e, _c, _r, _a, _f, _t));
endText(color);

// trick: use if defined instead of ifdef to not make it a shader option
#elif defined OLD
            beginText(ivec2(coord), ivec2(viewWidth / pixelSize / 2.0 - 13.0 * 7.0, 24.0));
text.bgCol = vec4(0.0);
text.fgCol = vec4(LOGO_COLORS[int(coord.x / 6.0 + frameTimeCounter * 4.0) % 16], 1.0);
printString((_U, _p, _g, _r, _a, _d, _e, _space, _I, _r, _i, _s, _space, _t, _o, _space, _u, _s, _e, _space, _t, _h, _i, _s, _space, _s, _h, _a, _d, _e, _r));
endText(color);
#else
        beginText(ivec2(coord), ivec2(viewWidth / pixelSize / 2.0 - 13.0 * 6.0, 110.0));
text.bgCol = vec4(0.0);
text.fgCol = vec4(LOGO_COLORS[int(coord.x / 6.0 + frameTimeCounter * 4.0) % 16], 1.0);
printString((_T, _h, _i, _s, _space, _s, _h, _a, _d, _e, _r, _space, _r, _e, _q, _u, _i, _r, _e, _s, _space, _I, _r, _i, _s, _colon))
endText(color);
beginText(ivec2(coord), ivec2(viewWidth / pixelSize / 2.0 - 7.5 * 6.0, 20.0));
text.bgCol = vec4(0.0);
text.fgCol = vec4(LOGO_COLORS[int(coord.x / 6.0 + frameTimeCounter * 4.0) % 16], 1.0);
printString((_i, _r, _i, _s, _s, _h, _a, _d, _e, _r, _s, _dot, _n, _e, _t));
endText(color);

#endif

    gl_FragData[0] = vec4(color, 1.0);
}
