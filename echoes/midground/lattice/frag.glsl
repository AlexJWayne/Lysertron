varying vec2 uvCoord;
varying vec3 vPos;

uniform vec3 color;

void main() {
  float alpha = 1.0 - pow(1.0 - uvCoord.y, 6.0);
  vec3 depthTint = color + vec3(smoothstep(0.0, 1.0, uvCoord.y));
  gl_FragColor = vec4(depthTint, alpha);
}