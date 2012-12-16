varying vec3 vPos;
varying vec2 uvCoord;

uniform float twist;
uniform float skew;
uniform float twistDir;

uniform vec3 bulge;

void main() {

  uvCoord = uv;
  vec4 vPos = modelViewMatrix * vec4(position, 1.0);
  vPos.xyz += sin(uv.y * 3.14159) * bulge;
  
  vPos.xy *= 0.9 + abs(uv.x * 2.0 - 1.0) * 0.1;

  gl_Position =  projectionMatrix * vPos;
}