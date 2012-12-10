varying vec2 uvCoord;
varying vec3 vPos;

uniform vec3 color;

void main() {
  float alpha = 1.0 - pow(1.0 - uvCoord.y, 2.0);
  gl_FragColor = vec4(color, alpha);
}