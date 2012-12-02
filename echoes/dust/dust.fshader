uniform vec4 color;
uniform vec3 baseColor;
uniform float particleAlpha;
uniform float crispness;

varying float depth;

float minmaxnorm(float min, float max, float val) {
  return (val - min) / (max - min);
}


void main() {
  vec2 point = gl_PointCoord * 2.0 - vec2(1.0);
  float circle = smoothstep(1.0, crispness, length(point));

  gl_FragColor = vec4(baseColor, circle * particleAlpha);
}