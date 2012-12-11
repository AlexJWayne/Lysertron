uniform vec3 color;

void main() {

  float circle = smoothstep(0.5, 0.45, length(gl_PointCoord - vec2(0.5)));

  gl_FragColor = vec4(color, circle);
}