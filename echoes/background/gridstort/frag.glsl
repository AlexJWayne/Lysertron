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
uniform float birth;
uniform float death;

const float UVSCALE = 10.0;

vec2 ripple() {
  vec2 normUV = (uvCoord - vec2(0.5)) * 2.0 * UVSCALE;

  float distortion = (1.0 + cos(length(normUV) * intensity - time * speed));
  float mainRipple = distortion * pow(amplitude, 3.0);

  return normUV * mainRipple;
}

void main() {
  vec2 coords = (uvCoord - vec2(0.5)) * UVSCALE;
  vec2 theRipple = ripple();

  // birth alpha
  float alpha = birth / length(coords);
  alpha = clamp(birth, 0.0, 1.0);

  // death alpha
  alpha *= (1.0 - death);

  // Highlight
  float highlight = dot(
    vec3(cos(spinSpeed * time), sin(spinSpeed * time), 0.0),
    normalize(vec3(theRipple, 1.0))
  );

  highlight = smoothstep(0.02, 0.2, abs(highlight)) * 0.6;

  // Add ripple
  coords = coords + theRipple;

  // Spin
  float spin = spinSpeed * time;
  coords = vec2(
    coords.x * cos(spin) - coords.y * sin(spin),
    coords.x * sin(spin) + coords.y * cos(spin)
  );

  // Drift
  coords += drift * time;

  // Grid
  float value = smoothstep(0.75, 0.85, abs(mod(coords.x, 1.0 / density) * density - 0.5) * 2.0);
  value      -= smoothstep(0.75, 0.85, abs(mod(coords.y, 1.0 / density) * density - 0.5) * 2.0) * 0.75;

  // Trough shadow
  float shadow = length(theRipple) * 0.75;

  //gl_FragColor = vec4(vec3(length(theRipple)), 1.0);
  gl_FragColor = vec4(baseColor + vec3(value * opacity) - vec3(shadow) + vec3(highlight), alpha);
}