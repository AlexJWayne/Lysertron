uniform float beatScale;
uniform vec4 color;
uniform vec3 tint;

varying vec3 vPos;
varying vec3 vNormal;

void main() {

  vec3 light = vec3(0.5, 0.2, 1.0);
  vec3 litColor = tint * max(0.0, dot(vNormal, light));
  
  vec3 lightness = vec3(1.0) * pow(beatScale, 2.5);

  gl_FragColor = vec4(litColor + lightness, 1.0);

}
