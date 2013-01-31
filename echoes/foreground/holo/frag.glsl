varying vec3 baseColor;
varying float depth;
varying float whiteningAmount;

uniform vec3 light;
uniform float specular;

void main() {

  // Fade color with distance
  float depthCue = 1.0 - smoothstep(100.0, 225.0, depth);

  // 2d coordinate form [1,1] to [-1,-1]
  vec2 coord = 2.0 * gl_PointCoord - vec2(1.0);

  // create a 3d normal as if particle is a sphere
  vec3 normal = normalize(vec3(
    coord.x,
    coord.y,
    1.0 - length(coord)
  ));

  // Compute lighting amount based on light position in uniform
  float lighting = dot(normal, light);
  lighting = clamp(lighting, 0.0, 1.0);
  lighting = pow(lighting, 3.0);

  // Constrain square particle to a circle
  float alphaCircle = smoothstep(1.0, 0.9, length(coord));

  // Make the very center a bit transparent
  float centerFade = (1.0 - clamp(length(coord), 0.0, 1.0)) * 0.5;

  gl_FragColor = vec4(
    // Color darkened by depth
    baseColor * depthCue

    // Lighting onSegment
    + vec3(whiteningAmount)

    // Lighten by the light source
    + vec3(lighting * specular),

    // Alpha
    alphaCircle
    + alphaCircle * (
      lighting * specular
      - centerFade
    )
  );
}