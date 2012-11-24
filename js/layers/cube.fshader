uniform float beatScale;
uniform vec4 color;
varying vec3 vPos;

uniform float colorR;
uniform float colorG;
uniform float colorB;

void main() {

  vec3 baseColor = vec3(colorR, colorG, colorB);
  vec3 normPos = normalize(vPos)/5.0 + baseColor;
  
  vec3 lightness = vec3(1.0)        * pow(beatScale, 2.5);
  vec3 darkness  = vec3(0.0) * (1.0 - pow(beatScale, 2.0));

  gl_FragColor = vec4(normPos + lightness - darkness*2.0, 1.0);

}
