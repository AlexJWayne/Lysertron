attribute float energy;

varying float age;

void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

  age = energy;

  float fl = 40.0;
  float scale = fl / (fl + gl_Position.z);
  gl_PointSize = 100.0 * scale;
}