(function() {
  var assets = {"frag.glsl":"varying vec3 baseColor;\nvarying float depth;\nvarying float whiteningAmount;\n\nvoid main() {\n  float depthCue = 1.0 - smoothstep(100.0, 225.0, depth);\n\n  float distance = length(gl_PointCoord - vec2(0.5)) * 2.0;\n  float alphaCircle = smoothstep(1.0, 0.9, distance);\n\n  gl_FragColor = vec4(baseColor * depthCue + vec3(whiteningAmount), alphaCircle);\n}","vert.glsl":"attribute vec3 vertexColor;\nattribute float whitening;\n\nuniform float size;\n\nvarying vec3 baseColor;\nvarying float depth;\nvarying float whiteningAmount;\n\nvoid main() {\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n  \n  whiteningAmount = whitening;\n  baseColor = vertexColor;\n  depth = gl_Position.z - cameraPosition.z;\n\n  float fl = 180.0;\n  float scale = fl / (fl + gl_Position.z);\n  gl_PointSize = size * scale;\n}"};
  var module = {};
  (function(){
    (function() {
  var Holo,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Holo = (function(_super) {

    __extends(Holo, _super);

    Holo.prototype.uniformAttrs = {
      size: 'f'
    };

    function Holo() {
      var u, v, vert, _i, _j, _ref, _ref1;
      Holo.__super__.constructor.apply(this, arguments);
      this.initParams();
      this.vertexAttrs = {
        whitening: {
          type: 'f',
          value: []
        },
        vertexColor: {
          type: 'c',
          value: []
        }
      };
      this.geometry = new THREE.Geometry;
      for (u = _i = 0, _ref = this.qty.segments; 0 <= _ref ? _i < _ref : _i > _ref; u = 0 <= _ref ? ++_i : --_i) {
        for (v = _j = 0, _ref1 = this.qty.chips; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; v = 0 <= _ref1 ? ++_j : --_j) {
          vert = new THREE.Vector3;
          vert.u = u / this.qty.segments;
          vert.v = v / this.qty.chips;
          this.geometry.vertices.push(vert);
          this.vertexAttrs.whitening.value.push(0);
          this.vertexAttrs.vertexColor.value.push(new THREE.Color().setHSV(vert.v, 1, 1).lerpSelf(this.baseColor, this.baseColorBlend));
        }
      }
      this.particles = new THREE.ParticleSystem(this.geometry, new THREE.ShaderMaterial({
        vertexColors: THREE.VertexColors,
        uniforms: this.uniforms,
        attributes: this.vertexAttrs,
        vertexShader: assets["vert.glsl"],
        fragmentShader: assets["frag.glsl"],
        transparent: true
      }));
      this.particles.rotation.set(THREE.Math.randFloat(0, 360..degToRad), THREE.Math.randFloat(0, 360..degToRad), THREE.Math.randFloat(0, 360..degToRad));
      this.animateBirth();
      this.particles.sortParticles = true;
      this.add(this.particles);
    }

    Holo.prototype.initParams = function() {
      var borderWidth;
      borderWidth = THREE.Math.randFloat(0.05, 0.4);
      this.baseColor = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.25, 1));
      this.baseColorBlend = [THREE.Math.randFloat(0, 1), 1].random();
      this.rotationSpeedX = THREE.Math.randFloatSpread(60..degToRad);
      this.rotationSpeedY = THREE.Math.randFloatSpread(60..degToRad);
      this.rotationSpeedZ = THREE.Math.randFloatSpread(60..degToRad);
      this.involutionSpeed = THREE.Math.randFloat(0.05, 0.2) * [1, -1].random();
      this.involution = 0;
      this.sizeOnBeat = THREE.Math.randFloat(25, 85);
      this.size = this.sizeOnBeat;
      this.r1 = 15 + TWEEN.Easing.Quadratic.In(Math.random()) * 25;
      this.r2 = THREE.Math.randFloat(this.r1 / 4, this.r1);
      this.border = false;
      return this.qty = {
        chips: THREE.Math.randInt(3, 24),
        segments: THREE.Math.randInt(32, 80)
      };
    };

    Holo.prototype.animateBirth = function() {
      var curves, r1, r2;
      r1 = this.r1;
      r2 = this.r2;
      this.r1 = this.r2 = 0;
      curves = [TWEEN.Easing.Sinusoidal, TWEEN.Easing.Cubic, TWEEN.Easing.Quadratic, TWEEN.Easing.Back];
      new TWEEN.Tween(this).to({
        r1: r1
      }, (1.5 / stage.song.bps).ms).easing(curves.random().Out).start();
      return new TWEEN.Tween(this).to({
        r2: r2
      }, (1 / stage.song.bps).ms).easing(curves.random().Out).start();
    };

    Holo.prototype.update = function(elapsed) {
      var amount, i, vert, _i, _j, _len, _ref, _ref1;
      this.size -= this.sizeOnBeat * elapsed / 3;
      if (this.size < 0) {
        this.size = 0;
      }
      this.particles.material.size = this.size;
      this.particles.rotation.x += this.rotationSpeedX * elapsed;
      this.particles.rotation.y += this.rotationSpeedY * elapsed;
      this.particles.rotation.z += this.rotationSpeedZ * elapsed;
      this.involution += this.involutionSpeed * elapsed;
      _ref = this.geometry.vertices;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vert = _ref[_i];
        this.placeVert(vert);
      }
      for (i = _j = 0, _ref1 = this.vertexAttrs.whitening.value.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
        amount = this.vertexAttrs.whitening.value[i];
        amount -= elapsed * 3;
        if (amount < 0) {
          amount = 0;
        }
        this.vertexAttrs.whitening.value[i] = amount;
      }
      return this.geometry.verticesNeedUpdate = true;
    };

    Holo.prototype.placeVert = function(vert) {
      var u, v;
      u = vert.u * 2 * Math.PI;
      v = vert.v * 2 * Math.PI;
      v += u;
      u += this.involution * 2 * Math.PI;
      return vert.set((this.r1 + this.r2 * Math.cos(u)) * Math.cos(v), (this.r1 + this.r2 * Math.cos(u)) * Math.sin(v), this.r2 * Math.sin(u) * 1.6180339887);
    };

    Holo.prototype.onBeat = function() {
      return this.size = this.sizeOnBeat;
    };

    Holo.prototype.onSegment = function(segment) {
      var i, pitches, vertIndex, vertex, whitenings, _i, _ref, _results;
      pitches = segment.pitches;
      if (!pitches) {
        return;
      }
      _results = [];
      for (vertIndex = _i = 0, _ref = this.geometry.vertices.length; 0 <= _ref ? _i < _ref : _i > _ref; vertIndex = 0 <= _ref ? ++_i : --_i) {
        vertex = this.geometry.vertices[vertIndex];
        whitenings = this.vertexAttrs.whitening.value;
        _results.push((function() {
          var _j, _ref1, _results1;
          _results1 = [];
          for (i = _j = 0, _ref1 = pitches.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
            if (i === Math.floor(vertex.v * 12)) {
              _results1.push(whitenings[vertIndex] = pitches[i]);
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        })());
      }
      return _results;
    };

    Holo.prototype.kill = function() {
      Holo.__super__.kill.apply(this, arguments);
      return this.sizeOnBeat *= 4;
    };

    Holo.prototype.alive = function() {
      return this.size > 0;
    };

    return Holo;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "holo";
  window.Echotron.Echoes.foreground.push(module.exports);
}());