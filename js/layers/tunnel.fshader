uniform float brightness;

uniform float colorR;
uniform float colorG;
uniform float colorB;

uniform vec4 color;
varying vec3 vPos;

void main() {
  vec3 baseColor = vec3(colorR, colorG, colorB) * brightness;

  float invBrightness = 1.0 - brightness;
  float ringVal = 1.0 - smoothstep(0.0, 0.1, abs(vPos.y / 10000.0 - invBrightness));
  ringVal *= 0.5;

  gl_FragColor = vec4(baseColor + vec3(ringVal), 1.0);
}