uniform vec4 color;

varying vec3 vPos;
varying vec3 vNormal;

void main() {

  vec3 light = vec3(0.0, 0.0, 1.0);
  float lightVal = abs(dot(vNormal, light));
  vec3 baseColor = vec3(0.5, 0.5, 0.5);

  gl_FragColor = vec4(mix(vec3(lightVal), baseColor, 0.5), 1.0);

}
