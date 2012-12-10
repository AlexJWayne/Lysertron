uniform vec3 color;

varying vec3 vPos;
varying vec3 vNormal;

void main() {
  float lightVal = smoothstep(0.45, 0.5, vNormal.y);
  gl_FragColor = vec4(mix(vec3(lightVal), color, 0.7), 1.0);
}
