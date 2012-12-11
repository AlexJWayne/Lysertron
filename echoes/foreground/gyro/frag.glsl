uniform vec3 color;

varying vec3 vPos;
varying vec3 vNormal;
varying vec2 uvCoord;

void main() {
  float lightVal = smoothstep(0.45, 0.5, vNormal.y);
  vec3 litColor = mix(vec3(lightVal), color, 0.7);
  gl_FragColor = vec4(litColor, 1.0);
}
