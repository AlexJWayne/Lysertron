varying vec2 uvCoord;

void main() {
  uvCoord = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}