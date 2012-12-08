varying vec3 vPos;
varying vec2 uvCoord;

uniform float twist;
uniform float skew;
uniform float twistDir;

void main() {
  // Pass to fragment shader
  vec3 transPos = (modelViewMatrix * vec4(position, 1.0)).xyz;
  uvCoord = uv;

  float depth = uv.y;
  float swirl = pow(depth, skew) * twist * twistDir;

  vec3 twisted = vec3(
    (transPos.x * cos(swirl) - transPos.y * sin(swirl)) * (1.0 - depth),
    (transPos.x * sin(swirl) + transPos.y * cos(swirl)) * (1.0 - depth),
    transPos.z
  );

  gl_Position =  projectionMatrix * vec4(twisted, 1.0);
}
