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

uniform vec2 ripplePositions[12]; // x, y
uniform vec3 rippleData[12];      // startTime, amplitude, frequency

const float UVSCALE = 10.0;
const float propogationSpeed = 0.75;

vec2 ripple(vec2 center, float started, float amp, float freq) {
  vec2 normUV = ((uvCoord - vec2(0.5)) * 2.0) * UVSCALE + center;

  float distortion = (1.0 + cos(length(normUV) * freq - time * speed));
  float mainRipple = distortion * pow(amp, 3.0);

  float distance = length(normUV);
  float sinceStart = time - started;
  
  // float freqSpeedCoef = smoothstep(350.0, 50.0, freq) + 1.0;

  float attenuation = smoothstep(propogationSpeed * sinceStart, 0.0, distance);
  // lower effect in center?
  
  return normUV * mainRipple * attenuation;
}

void main() {
  vec2 coords = (uvCoord - vec2(0.5)) * UVSCALE;
  vec2 theRipples = vec2(0.0);
  for (int i = 0; i < 12; i++) {
    theRipples += ripple(
      ripplePositions[i],
      rippleData[i].x,
      rippleData[i].y,
      rippleData[i].z
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
    baseColor
    + vec3(grid * opacity)
    + vec3(highlight)
    - vec3(shadow)
  );

  gl_FragColor.w = alpha;
}