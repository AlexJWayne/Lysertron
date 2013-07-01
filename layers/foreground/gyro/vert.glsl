varying vec3 vPos;
varying vec3 vNormal;
varying vec3 screenNormal;
varying vec2 uvCoord;

uniform float progress;

void main() {
  // Pass to fragment shader
  vPos = position;
  vNormal = normal;
  screenNormal = (projectionMatrix * modelViewMatrix * vec4(normal, 1.0)).xyz;
  uvCoord = uv;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
