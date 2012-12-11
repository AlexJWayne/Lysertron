varying vec2 uvCoord;

uniform float time;
uniform float amplitude;
uniform vec3 baseColor;
uniform float density;
uniform float opacity;
uniform float speed;

vec2 ripple() {
  vec2 normUV = (uvCoord - vec2(0.5)) * 2.0;

  float len = length(normUV);
  len = (1.0 + cos(len * 26.0 - time * speed)) / 2.0;

  return normUV * len * pow(amplitude, 3.0);
}

void main() {
  // TODO: uniformify
  vec2 drift = vec2(0.01, 0.02);
  float spin = 0.1 * time;
  // ----

  vec2 coords = uvCoord;

  // Drift
  coords += drift * time;

  // Add ripple
  coords = coords + ripple();

  // Spin
  coords = vec2(
    coords.x * cos(spin) - coords.y * sin(spin),
    coords.x * sin(spin) + coords.y * cos(spin)
  );

  float value = smoothstep(0.6, 0.8, abs(mod(coords.x, 1.0/density)*density - 0.5) * 2.0);
  value      += smoothstep(0.6, 0.8, abs(mod(coords.y, 1.0/density)*density - 0.5) * 2.0);

  gl_FragColor = vec4(baseColor + vec3(value * opacity), 1.0);
}