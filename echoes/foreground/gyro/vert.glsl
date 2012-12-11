varying vec3 vPos;
varying vec3 vNormal;
varying vec2 uvCoord;

uniform float pulse;
uniform float progress;

void main() {
  // Pass to fragment shader
  vPos = position;
  vNormal = (projectionMatrix * modelViewMatrix * vec4(normal, 1.0)).xyz;
  uvCoord = uv;

  float growth = smoothstep(0.0, 0.2, clamp(progress, 0.0, 1.0));
  vec3 pulsed = position + normal * (1.0 - growth) * pulse;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(pulsed, 1.0);
}
