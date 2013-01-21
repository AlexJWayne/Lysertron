varying vec3 baseColor;
varying float depth;
varying float whiteningAmount;

void main() {
  float depthCue = 1.0 - smoothstep(100.0, 225.0, depth);

  float distance = length(gl_PointCoord - vec2(0.5)) * 2.0;
  float alphaCircle = smoothstep(1.0, 0.9, distance);

  gl_FragColor = vec4(baseColor * depthCue + vec3(whiteningAmount), alphaCircle);
}