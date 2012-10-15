uniform float beatScale;
uniform vec4 color;
varying vec3 vPos;

void main() {

  vec3 normPos = (normalize(vPos) + vec3(1, 1, 1)) / vec3(2, 2, 2);
  
  vec3 lightness = vec3(1.0)        * pow(beatScale, 3.0);
  vec3 darkness  = vec3(0.0) * (1.0 - pow(beatScale, 3.0));

  gl_FragColor = vec4(normPos + lightness - darkness, 1.0);

}
