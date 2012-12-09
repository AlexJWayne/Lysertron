uniform vec3 color;

varying vec3 vPos;
varying vec3 vNormal;

void main() {
  float lightVal = 1.0;
  if (vNormal.y > 0.5) lightVal = 0.0;

  gl_FragColor = vec4(mix(vec3(lightVal), color, 0.7), 1.0);

}
