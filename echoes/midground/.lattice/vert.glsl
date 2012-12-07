varying vec3 vPos;

void main() {
  // Pass to fragment shader
  vPos = position;
  
  vec4 worldPos = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  float depth = uv.y;
  float swirl = depth * 8.0;

  vec4 twisted = vec4(worldPos);
  twisted.x = worldPos.x * cos(swirl) - worldPos.y * sin(swirl);
  twisted.y = worldPos.x * sin(swirl) + worldPos.y * cos(swirl);

  gl_Position = twisted;
}
