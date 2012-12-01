uniform float inward;
uniform float brightness;
uniform float ease;
uniform float ringSize;
uniform float ringIntensity;

uniform float ripples[8];
uniform vec3 baseColor;
uniform vec3 ringColor;

uniform vec4 color;
varying vec3 vPos;

void main() {
  vec3 dimmedColor = baseColor * brightness;

  float rings = 0.0;
  for (int i = 0; i < 4; i++) {
    float progress = pow(abs(inward - ripples[i]), ease);
    float ringPos = abs(vPos.y / 1000.0 - progress);
    float ringVal = 1.0 - smoothstep(0.0, 0.1 * ringSize, ringPos);
    rings += clamp(ringVal * ripples[i], 0.0, 1.0);
  }

  gl_FragColor = vec4(dimmedColor + ringColor*rings*ringIntensity, 1.0);
}