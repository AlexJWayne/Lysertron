vec3 torus(float angle1, float angle2) {
  float r1 = 20.0;
  float r2 = 10.0;

  angle2 = angle1 + angle2;

  return vec3(
    (r1 + r2 * cos(angle1)) * cos(angle2),
    (r1 + r2 * cos(angle1)) * sin(angle2),
    r2 * sin(angle1) * 1.61803 // PHI
  );
}

void main() {

  vec3 torusPos = torus(position.x, position.y);

  gl_PointSize = 10.0;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(torusPos, 1.0);
}