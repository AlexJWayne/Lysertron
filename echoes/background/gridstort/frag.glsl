varying vec2 uvCoord;

uniform float time;
uniform float amplitude;
uniform vec3 baseColor;
uniform float density;
uniform float opacity;
uniform float speed;
uniform float spinSpeed;
uniform vec2 drift;
uniform float intensity;

vec2 ripple() {
  vec2 normUV = (uvCoord - vec2(0.5)) * 2.0;

  float len = length(normUV);
  len = (1.0 + cos(len * intensity - time * speed));

  return normUV * len * pow(amplitude, 3.0) * 0.75;
}

void main() {
  vec2 coords = (uvCoord - vec2(0.5));

  // Drift
  coords += drift * time;

  // Add ripple
  vec2 theRipple = ripple();
  coords = coords + theRipple;

  // Spin
  float spin = spinSpeed * time;
  coords = vec2(
    coords.x * cos(spin) - coords.y * sin(spin),
    coords.x * sin(spin) + coords.y * cos(spin)
  );

  // Grid
  float value = smoothstep(0.6, 1.0, abs(mod(coords.x, 1.0 / density) * density - 0.5) * 2.0);
  value      -= smoothstep(0.6, 1.0, abs(mod(coords.y, 1.0 / density) * density - 0.5) * 2.0);

  // Vertical Tint
  vec3 tint = baseColor * pow(uvCoord.y, 4.0) * 3.0;

  gl_FragColor = vec4(baseColor + tint + vec3(value * opacity) - vec3(length(theRipple) * 0.75), 1.0);
}