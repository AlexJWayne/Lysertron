uniform float size;

varying float depth;

float minmaxnorm(float min, float max, float val) {
  return (val - min) / (max - min);
}

void main() {
  vec4 projectedPos = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  depth = minmaxnorm(100.0, -50.0, projectedPos.z);

  gl_PointSize = depth * size * 10.0;
  gl_Position = projectedPos;
}


