void main() {

  vec3 color = vec3(1.0, 1.0, 0.0);
  float circle = smoothstep(0.5, 0.45, length(gl_PointCoord - vec2(0.5)));

  gl_FragColor = vec4(color, circle);
}