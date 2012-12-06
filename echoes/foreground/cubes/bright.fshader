uniform float beatScale;
uniform vec4 color;

varying vec3 vPos;

uniform vec3 tint;

void main() {

  vec3 normPos = normalize(vPos)/6.0 + tint;
  
  vec3 lightness = vec3(1.0)        * pow(beatScale, 2.5);
  vec3 darkness  = vec3(0.0) * (1.0 - pow(beatScale, 2.0));

  gl_FragColor = vec4(normPos + lightness - darkness*2.0, 1.0);

}
