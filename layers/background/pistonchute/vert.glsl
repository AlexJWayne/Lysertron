varying vec2 uvCoord;
varying vec3 vNormal;
varying float depth;

void main() {
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  
  uvCoord = uv;
  vNormal = normal;
  depth = gl_Position.z;
}