uniform vec3 color;
uniform float progress;
uniform float elapsed;
uniform float lightenOnNudge;

uniform float lightRingBrightness;
uniform float lightRingWidths[3];
uniform float lightRingSpeeds[3];

varying vec3 vPos;
varying vec3 vNormal;
varying vec3 screenNormal;
varying vec2 uvCoord;

float snoise(vec2 v);

float lightRing(float width, float speed) {
  float x = uvCoord.x;
  float slowness = 1.0 / speed;
  float ringLightProgress = mod(elapsed, slowness) / slowness;
  
  float result = 0.0;
  result += smoothstep(width, 0.0, abs(x       - ringLightProgress));
  result += smoothstep(width, 0.0, abs(x - 1.0 - ringLightProgress));
  result += smoothstep(width, 0.0, abs(x + 1.0 - ringLightProgress));

  float noise = snoise(uvCoord * 60.0 - vec2(1.0, elapsed) * 20.0);

  result = result * 0.85 * lightRingBrightness;
  result *= 0.95 + noise * 0.15;
  return result;
}

void main() {
  float lightVal = dot(vec3(0.0, 1.0, 0.0), screenNormal) * 0.75;
  lightVal      += dot(vec3(1.0, 0.0, 0.0), screenNormal) * 0.5;

  // Attenuate light
  lightVal = pow(abs(lightVal), 4.0);
  gl_FragColor.xyz = mix(vec3(lightVal), color, 0.7);

  // pulse color
  gl_FragColor.xyz += vec3(pow((1.0 - progress), 2.0)) * lightenOnNudge;

  // large blurry noise for unlit portion
  gl_FragColor.xyz += vec3(snoise(screenNormal.xy + vec2(elapsed))) * 0.075;

  // ring lights
  float lights = 0.0;
  for (int i = 0; i < 3; i++) {
    lights += lightRing(lightRingWidths[i], lightRingSpeeds[i]);
  }
  gl_FragColor.xyz += vec3(lights);

  // alpha
  gl_FragColor.w =
    lightVal * 0.4 + 0.7
    + (1.0 - progress)
    + lights;
}






// https://github.com/ashima/webgl-noise/blob/master/src/noise2D.glsl

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
// 

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
  // First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

  // Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    + i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

  // Gradients: 41 points uniformly over a line, mapped onto a diamond.
  // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  // Normalise gradients implicitly by scaling m
  // Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

  // Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}