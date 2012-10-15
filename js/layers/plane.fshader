uniform float brightness;

uniform float angle;
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
  float rotX = cos(angle) * vPos.x + sin(angle) * vPos.y;
  float rotY = cos(angle) * vPos.y - sin(angle) * vPos.x;
  
  float x = pow(abs(0.5 - mod(rotX + shiftX, size) / size) * 2.0, 4.0);
  float y = pow(abs(0.5 - mod(rotY + shiftY, size) / size) * 2.0, 4.0);

  return (x+y) * 5.0 * pow(brightness, 3.0);
}

void main() {

  float fog;
  float distance = length(vPos);

  fog = 1.0 - (distance - 4000.0) / 10000.0;
  fog = clamp(fog, 0.0, 1.0);

  gl_FragColor = vec4(
    vec3(
      grid(gridSizeR, shiftXr, shiftYr) * 0.5,
      grid(gridSizeG, shiftXg, shiftYg) * 0.5,
      grid(gridSizeB, shiftXb, shiftYb) * 1.3
    ) * fog,
    1.0
  );
}