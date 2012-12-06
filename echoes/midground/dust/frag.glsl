uniform vec4 color;
uniform vec3 baseColor;
uniform float particleAlpha;

varying float depth;

const float maxBlur = 0.45;

float minmaxnorm(float min, float max, float val) {
  return (val - min) / (max - min);
}


void main() {

  float min = 0.5;
  float max = 0.45;
  
  float blur = minmaxnorm(0.1, 0.5, depth);
  blur = clamp(blur, 0.0, 1.0);
  min += blur * maxBlur;
  max -= blur * maxBlur;

  vec2 point = gl_PointCoord * 2.0 - vec2(1.0);
  float circle = smoothstep(min, max, length(point));

  gl_FragColor = vec4(
    baseColor,
    circle * particleAlpha * (1.0 - blur*0.35)
  );
}