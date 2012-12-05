varying vec3 vPos;
varying vec3 vNormal;

void main() {
  // Pass to fragment shader
  vPos = position;
  vNormal = normal;

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
