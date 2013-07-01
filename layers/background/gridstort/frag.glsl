varying vec2 uvCoord;

uniform float time;
uniform vec3 baseColor;
uniform float density;
uniform float opacity;
uniform float speed;
uniform float spinSpeed;
uniform vec2 drift;
uniform float birth;
uniform float death;

uniform vec2 ripplePositions[18]; // x, y
uniform vec3 rippleData[18];      // startTime, amplitude, frequency

const float UVSCALE = 10.0;
const float propogationSpeed = 0.75;

vec2 ripple(vec2 center, float started, float amp, float freq) {
  vec2 normUV = ((uvCoord - vec2(0.5)) * 2.0) * UVSCALE + center;

  float distortion = (1.0 + cos(length(normUV) * freq - time * speed * (freq / 30.0)));
  float mainRipple = distortion * pow(amp, 3.0);

  float distance = length(normUV);
  float sinceStart = time - started;
  float attenuation = smoothstep(propogationSpeed * sinceStart, 0.0, distance);
  
  // lower effect in center
  attenuation *= smoothstep(propogationSpeed * sinceStart - (60.0 / freq), propogationSpeed * sinceStart, distance);
  
  return normUV * mainRipple * attenuation;
}

float highlightRippleStart(vec2 center, float started, float amp) {
  vec2 normUV = ((uvCoord - vec2(0.5)) * 2.0) * UVSCALE + center;
  float distance = length(normUV) * (time - started + 0.25);
  return smoothstep(0.075 * (amp - 0.5), 0.0, distance) * smoothstep(1.0, 0.0, time - started) * 0.65;
}

void main() {
  vec2 coords = (uvCoord - vec2(0.5)) * UVSCALE;
  
  vec2 theRipples = vec2(0.0);
  float rippleStarts = 0.0;

  for (int i = 0; i < 18; i++) {
    theRipples += ripple(
      ripplePositions[i],
      rippleData[i].x,
      rippleData[i].y,
      rippleData[i].z
    );

    rippleStarts += highlightRippleStart(
      ripplePositions[i],
      rippleData[i].x,
      rippleData[i].y
    );
  }
  

  // birth alpha
  float alpha = birth / length(coords);
  alpha = clamp(birth, 0.0, 1.0);

  // death alpha
  alpha *= (1.0 - death);

  // Highlight
  float highlight = dot(
    vec3(cos(spinSpeed * time), sin(spinSpeed * time), 0.0),
    normalize(vec3(theRipples, 1.0))
  );

  highlight = smoothstep(0.02, 0.2, abs(highlight)) * 0.6;

  // Add ripple
  coords = coords + theRipples;

  // Spin
  float spin = spinSpeed * time;
  coords = vec2(
    coords.x * cos(spin) - coords.y * sin(spin),
    coords.x * sin(spin) + coords.y * cos(spin)
  );

  // Drift
  coords += drift * time;

  // Grid
  float grid = smoothstep(0.75, 0.85, abs(mod(coords.x, 1.0 / density) * density - 0.5) * 2.0);
  grid      -= smoothstep(0.75, 0.85, abs(mod(coords.y, 1.0 / density) * density - 0.5) * 2.0) * 0.75;

  // Trough shadow
  float shadow = length(theRipples) * 0.75;

  
  gl_FragColor.xyz = (
    baseColor + rippleStarts
    + vec3(grid * opacity)
    + vec3(highlight)
    - vec3(shadow)
  );

  gl_FragColor.w = alpha;
}