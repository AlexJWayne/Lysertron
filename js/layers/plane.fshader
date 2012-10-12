uniform float brightness;
uniform float shiftXr;
uniform float shiftYr;
uniform float shiftXg;
uniform float shiftYg;
uniform float shiftXb;
uniform float shiftYb;

uniform float gridSizeR;
uniform float gridSizeG;
uniform float gridSizeB;

uniform vec4 color;
varying vec3 vPos;

float grid(float size, float shiftX, float shiftY) {
  float x = pow(abs(0.5 - mod(vPos.x + shiftX * size, size) / size) * 2.0, 4.0);
  float y = pow(abs(0.5 - mod(vPos.y + shiftY * size, size) / size) * 2.0, 4.0);
  return (x+y) * 5.0 * pow(brightness, 3.0);
}

void main() {
  gl_FragColor = vec4(
    grid(gridSizeR, shiftXr, shiftYr) * 0.5,
    grid(gridSizeG, shiftXg, shiftYg) * 0.5,
    grid(gridSizeB, shiftXb, shiftYb) * 1.3,
    1.0
  );
}