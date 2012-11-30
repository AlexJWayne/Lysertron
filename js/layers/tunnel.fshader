uniform float brightness;
uniform float ease;
uniform float ringSize;

uniform float ripples[4];
uniform vec3 baseColor;

uniform vec4 color;
varying vec3 vPos;

void main() {
  vec3 dimmedColor = baseColor * brightness;

  float rings = 0.0;
  for (int i = 0; i < 4; i++) {
    float progress = pow(1.0 - ripples[i], ease);
    float ringVal = 1.0 - smoothstep(0.0, 0.1 * ringSize, abs(vPos.y / 10000.0 - progress));
    rings += clamp(ringVal * pow(ripples[i], ease), 0.0, 1.0);
  }

  gl_FragColor = vec4(dimmedColor + vec3(rings) * 0.8, 1.0);
}