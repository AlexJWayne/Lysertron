varying vec3 vPos;
varying vec2 uvCoord;

uniform float twist;
uniform float skew;
uniform float twistDir;

void main() {
  uvCoord = uv;
  gl_Position =  projectionMatrix * modelViewMatrix * vec4(position, 1.0);  
}