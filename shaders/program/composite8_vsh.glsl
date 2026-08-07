flat out mat4 reprojectionMatrix;
out vec2 texCoord;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

void main() {
    gl_Position = ftransform();
    reprojectionMatrix = gbufferPreviousProjection * gbufferPreviousModelView * mat4(vec4(1, 0, 0, 0), vec4(0, 1, 0, 0), vec4(0, 0, 1, 0), vec4(cameraPosition - previousCameraPosition, 1)) * gbufferModelViewInverse * gbufferProjectionInverse;
    texCoord = 0.5 * gl_Position.xy + 0.5;
}