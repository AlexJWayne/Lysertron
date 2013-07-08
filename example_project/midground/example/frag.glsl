// Simple fragment shader that displays the object in the baseColor.

uniform vec3 baseColor;

void main() {
  gl_FragColor = vec4(baseColor, 1.0);
}
