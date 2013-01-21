varying vec3 baseColor;
varying float depth;
varying float whiteningAmount;

uniform float borderStart;
uniform float borderEnd;

void main() {
  float depthCue = 1.0 - smoothstep(100.0, 225.0, depth);

  float distance = length(gl_PointCoord - vec2(0.5)) * 2.0;
  float alphaCircle = smoothstep(1.0, 0.9, distance);
  float colorCircle = smoothstep(borderStart, borderEnd, distance);

  gl_FragColor = vec4(baseColor * depthCue * colorCircle + vec3(whiteningAmount), alphaCircle);
}