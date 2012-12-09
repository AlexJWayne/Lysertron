varying vec2 uvCoord;
varying vec3 vPos;

uniform vec3 color;

void main() {
  gl_FragColor = vec4(color, uvCoord.y);
}