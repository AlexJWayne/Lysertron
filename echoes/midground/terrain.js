(function() {
  var assets = {"frag.glsl":"uniform vec3 baseColor;\nuniform float beatValue;\n\nvarying float height;\nvarying float distance;\n\nfloat expEaseOut(float n) {\n  return 1.0 - pow(2.0, -3.0 * n);\n}\n\nvoid main() {\n  float depthCue = smoothstep(1000.0, 750.0, distance);\n  \n  vec3 finalColor = baseColor;\n  if (height > beatValue) {\n    finalColor += vec3(1.0) * beatValue;\n  }\n\n  gl_FragColor = vec4(\n    finalColor,\n    expEaseOut(height) * depthCue\n  );\n}","vert.glsl":"uniform vec2 travel;\nuniform float smoothness;\nuniform float maxHeight;\n\nvarying float height;\nvarying float distance;\n\nfloat snoise(vec2 v);\n\nvoid main() {\n  vec3 noisedPos = position;\n\n  vec2 smoothedTravel = travel / (smoothness/100.0);\n  height  = snoise(  position.xy        / smoothness + smoothedTravel) * 0.7;\n  height += snoise(-(position.xy / 2.0) / smoothness + smoothedTravel) * 0.3;\n\n  noisedPos.z = height * maxHeight;\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(noisedPos, 1.0);\n\n  // Export to frag shader\n  distance = length(gl_Position.xyz);\n}\n\n\n\n\n// https://github.com/ashima/webgl-noise/blob/master/src/noise2D.glsl\n\n//\n// Description : Array and textureless GLSL 2D simplex noise function.\n//      Author : Ian McEwan, Ashima Arts.\n//  Maintainer : ijm\n//     Lastmod : 20110822 (ijm)\n//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.\n//               Distributed under the MIT License. See LICENSE file.\n//               https://github.com/ashima/webgl-noise\n// \n\nvec3 mod289(vec3 x) {\n  return x - floor(x * (1.0 / 289.0)) * 289.0;\n}\n\nvec2 mod289(vec2 x) {\n  return x - floor(x * (1.0 / 289.0)) * 289.0;\n}\n\nvec3 permute(vec3 x) {\n  return mod289(((x*34.0)+1.0)*x);\n}\n\nfloat snoise(vec2 v) {\n  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0\n                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)\n                     -0.577350269189626,  // -1.0 + 2.0 * C.x\n                      0.024390243902439); // 1.0 / 41.0\n  // First corner\n  vec2 i  = floor(v + dot(v, C.yy) );\n  vec2 x0 = v -   i + dot(i, C.xx);\n\n  // Other corners\n  vec2 i1;\n  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0\n  //i1.y = 1.0 - i1.x;\n  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);\n  // x0 = x0 - 0.0 + 0.0 * C.xx ;\n  // x1 = x0 - i1 + 1.0 * C.xx ;\n  // x2 = x0 - 1.0 + 2.0 * C.xx ;\n  vec4 x12 = x0.xyxy + C.xxzz;\n  x12.xy -= i1;\n\n// Permutations\n  i = mod289(i); // Avoid truncation effects in permutation\n  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))\n    + i.x + vec3(0.0, i1.x, 1.0 ));\n\n  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);\n  m = m*m ;\n  m = m*m ;\n\n  // Gradients: 41 points uniformly over a line, mapped onto a diamond.\n  // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)\n\n  vec3 x = 2.0 * fract(p * C.www) - 1.0;\n  vec3 h = abs(x) - 0.5;\n  vec3 ox = floor(x + 0.5);\n  vec3 a0 = x - ox;\n\n  // Normalise gradients implicitly by scaling m\n  // Approximation of: m *= inversesqrt( a0*a0 + h*h );\n  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );\n\n  // Compute final noise value at P\n  vec3 g;\n  g.x  = a0.x  * x0.x  + h.x  * x0.y;\n  g.yz = a0.yz * x12.xz + h.yz * x12.yw;\n  return 130.0 * dot(m, g);\n}"};
  var module = {};
  (function(){
    (function() {
  var Terrain, Terrains,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Terrains = (function(_super) {

    __extends(Terrains, _super);

    function Terrains() {
      Terrains.__super__.constructor.apply(this, arguments);
      this.bottom = new Terrain;
      this.top = new Terrain;
      this.top.rotation.z = 180..degToRad;
      this.push(this.bottom);
      this.push(this.top);
    }

    return Terrains;

  })(Echotron.EchoStack);

  Terrain = (function(_super) {

    __extends(Terrain, _super);

    Terrain.prototype.uniformAttrs = {
      smoothness: 'f',
      travel: 'v2',
      maxHeight: 'f',
      beatValue: 'f',
      baseColor: 'c'
    };

    Terrain.prototype.geom = new THREE.PlaneGeometry(1500, 1000, 150, 100);

    function Terrain() {
      Terrain.__super__.constructor.apply(this, arguments);
      this.undulation = THREE.Math.randFloat(0.5, 1.5);
      this.smoothness = THREE.Math.randFloat(125, 300);
      this.maxHeight = THREE.Math.randFloat(75, 160);
      this.baseColor = new THREE.Color().setHSV(Math.random(), THREE.Math.randFloat(0.5, 1), 1);
      this.travelSpeed = new THREE.Vector2([0, THREE.Math.randFloat(0, 0.2)]);
      this.travel = new THREE.Vector2(Math.random() * 100, Math.random() * 100);
      this.beatValue = 1;
      this.terrain = new THREE.Mesh(this.geom, new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets['vert.glsl'],
        fragmentShader: assets['frag.glsl']
      }));
      this.terrain.rotation.x = -90..degToRad;
      this.terrain.position.y = -200;
      this.terrain.position.z = 500;
      this.add(this.terrain);
    }

    Terrain.prototype.update = function(elapsed) {
      this.beatValue -= elapsed * 2;
      if (this.beatValue < 0) {
        this.beatValue = 0;
      }
      return this.travel.y -= this.undulation * elapsed;
    };

    Terrain.prototype.onBeat = function() {
      return this.beatValue = 1;
    };

    Terrain.prototype.kill = function() {
      Terrain.__super__.kill.apply(this, arguments);
      return new TWEEN.Tween(this.terrain.position).to({
        y: -1010
      }, 3..ms).easing(TWEEN.Easing.Quadratic.In).start();
    };

    Terrain.prototype.alive = function() {
      return this.terrain.position.y > -1000;
    };

    return Terrain;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "terrain";
  window.Echotron.Echoes.midground.push(module.exports);
}());