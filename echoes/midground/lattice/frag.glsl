varying vec2 uvCoord;
varying vec3 vPos;

uniform vec3 color;
uniform float glow;

void main() {
  float alpha = 1.0 - pow(1.0 - uvCoord.y, 7.0);
  vec3 depthTint = color + vec3(smoothstep(0.0, 1.0, uvCoord.y));

  float shadow = abs(uvCoord.x * 2.0 - 1.0) * 0.15;
  
  gl_FragColor = vec4(depthTint - vec3(shadow) + vec3(glow), alpha);
}