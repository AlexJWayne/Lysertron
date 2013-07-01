uniform vec3 baseColor;
uniform float darkening;

varying float age;

void main() {
  float distance = length(gl_PointCoord - vec2(0.5)) * 2.0;
  float alphaCircle = 1.0 - distance;
  float core = smoothstep(0.2, 0.0, distance);
  float darken = smoothstep(0.2, 1.0, age);

  gl_FragColor = vec4(
    (baseColor + vec3(age * 1.5 - core)) * pow(age, darkening),
    alphaCircle * age
  );
}