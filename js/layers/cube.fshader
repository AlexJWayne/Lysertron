uniform float beatScale;
uniform vec4 color;
varying vec3 vPos;

void main() {

  vec3 normPos = (normalize(vPos) + vec3(1, 1, 1)) / vec3(2, 2, 2);
  
  //normPos.x = sin(normPos.x + beatScale);
  //normPos.z = cos(normPos.z - beatScale);
  //
  //float alpha;
  //if (normPos.y < beatScale - 0.1) {
  //  alpha = 0.0;
  //} else if (normPos.y < beatScale) {
  //  alpha = 1.0 - (beatScale - normPos.y) / 0.1;
  //} else {
  //  alpha = 1.0;
  //}

  gl_FragColor = color + vec4(normPos, 1.0);

}
