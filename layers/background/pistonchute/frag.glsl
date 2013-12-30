varying vec2 uvCoord;
varying vec3 vNormal;
varying float depth;

uniform vec3 baseColor;

void main() {
  gl_FragColor.xyz = baseColor;

  // Apply some basic lighting
  vec3 light = vec3(0.5, 0.4, 1.0);
  float lightScalar = abs(dot(vNormal, light));
  lightScalar += 0.2; // ambient
  gl_FragColor.xyz *= lightScalar;

  // Apply fog
  float fog = smoothstep(1000.0, 150.0, depth);
  gl_FragColor.xyz *= fog;
}