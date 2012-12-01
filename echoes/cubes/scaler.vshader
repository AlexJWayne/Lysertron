uniform float beatScale;

varying vec3 vPos;
varying vec3 vNormal;

void main() {
  // Pass to fragment shader
  vPos = position;
  vNormal = normal;

  vec3 scaledPos = vPos * beatScale * beatScale;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(scaledPos, 1.0);
}
