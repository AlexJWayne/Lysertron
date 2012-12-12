(function() {
  var assets = {"frag.glsl":"uniform vec4 color;\nuniform vec3 baseColor;\nuniform float particleAlpha;\n\nvarying float depth;\n\nconst float maxBlur = 0.45;\n\nfloat minmaxnorm(float min, float max, float val) {\n  return (val - min) / (max - min);\n}\n\n\nvoid main() {\n\n  float min = 0.5;\n  float max = 0.45;\n  \n  float blur = minmaxnorm(0.1, 0.5, depth);\n  blur = clamp(blur, 0.0, 1.0);\n  min += blur * maxBlur;\n  max -= blur * maxBlur;\n\n  vec2 point = gl_PointCoord * 2.0 - vec2(1.0);\n  float circle = smoothstep(min, max, length(point));\n\n  gl_FragColor = vec4(\n    baseColor,\n    circle * particleAlpha * (1.0 - blur*0.35)\n  );\n}","vert.glsl":"uniform float size;\n\nvarying float depth;\n\nfloat minmaxnorm(float min, float max, float val) {\n  return (val - min) / (max - min);\n}\n\nvoid main() {\n  vec4 projectedPos = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n  depth = minmaxnorm(100.0, -100.0, projectedPos.z);\n\n  gl_PointSize = depth * size * 20.0;\n  gl_Position = projectedPos;\n}\n\n\n"};
  var module = {};
  (function(){
    (function() {
  var Dust,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Dust = (function(_super) {

    __extends(Dust, _super);

    Dust.prototype.uniformAttrs = {
      baseColor: 'c',
      size: 'f',
      particleAlpha: 'f'
    };

    function Dust() {
      var i, _i, _ref;
      Dust.__super__.constructor.apply(this, arguments);
      this.direction = 1;
      this.speed = THREE.Math.randFloat(2, 4);
      this.damp = THREE.Math.randFloat(1, 4);
      this.vel = 3;
      this.size = THREE.Math.randFloat(3, 8);
      this.position.z = Math.random();
      this.scale.setLength(0);
      this.particleAlpha = THREE.Math.randFloat(0.3, 0.6);
      this.baseColor = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0, 0.25), 1);
      this.spin = new THREE.Vector3(THREE.Math.randFloatSpread(30).rad, THREE.Math.randFloatSpread(30).rad, THREE.Math.randFloatSpread(30).rad);
      this.geom = new THREE.Geometry;
      for (i = _i = 0, _ref = THREE.Math.randFloat(250, 1000); 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.geom.vertices.push(new THREE.Vector3(THREE.Math.randFloat(-1, 1), THREE.Math.randFloat(-1, 1), THREE.Math.randFloat(-1, 1)).setLength(THREE.Math.randFloat(4, 70)));
      }
      this.particles = new THREE.ParticleSystem(this.geom, new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets["vert.glsl"],
        fragmentShader: assets["frag.glsl"],
        transparent: true,
        depthWrite: false
      }));
      this.add(this.particles);
    }

    Dust.prototype.beat = function() {
      this.vel = this.speed * this.direction;
      return this.direction *= -1;
    };

    Dust.prototype.update = function(elapsed) {
      Dust.__super__.update.apply(this, arguments);
      this.vel -= this.vel * this.damp * elapsed;
      this.scale.addSelf(THREE.Vector3.temp(1, 1, 1).multiplyScalar(this.vel * elapsed));
      return this.rotation.addSelf(THREE.Vector3.temp(this.spin).multiplyScalar(elapsed));
    };

    Dust.prototype.kill = function() {
      Dust.__super__.kill.apply(this, arguments);
      this.vel = this.speed * 2;
      return this.damp = 0;
    };

    Dust.prototype.alive = function() {
      return this.scale.length() < 50;
    };

    return Dust;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "dust";
  window.Echotron.Echoes.midground.push(module.exports);
}());