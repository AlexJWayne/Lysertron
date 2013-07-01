// Default vertex shader that does just enough to work.
void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
