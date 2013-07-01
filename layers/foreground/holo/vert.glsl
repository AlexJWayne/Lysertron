attribute vec3 vertexColor;
attribute float whitening;

uniform float size;

varying vec3 baseColor;
varying float depth;
varying float whiteningAmount;

void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  
  whiteningAmount = whitening;
  baseColor = vertexColor;
  depth = gl_Position.z - cameraPosition.z;

  float fl = 180.0;
  float scale = fl / (fl + gl_Position.z);
  gl_PointSize = size * scale;
}