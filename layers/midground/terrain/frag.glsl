uniform vec3 baseColor;
uniform float beatValue;

varying float height;
varying float distance;

float expEaseOut(float n) {
  return 1.0 - pow(2.0, -3.0 * n);
}

void main() {
  float depthCue = smoothstep(1000.0, 750.0, distance);
  
  vec3 finalColor = baseColor;
  if (height > beatValue) {
    finalColor += vec3(1.0) * beatValue;
  }

  gl_FragColor = vec4(
    finalColor,
    expEaseOut(height) * depthCue
  );
}