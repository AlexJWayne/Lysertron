varying vec3 vPos;

void main() {
  // Pass to fragment shader
  vPos = position;
  
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
