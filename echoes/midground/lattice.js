(function() {
  var assets = {"frag.glsl":"varying vec2 uvCoord;\nvarying vec3 vPos;\n\nuniform vec3 color;\n\nvoid main() {\n  float alpha = 1.0 - pow(1.0 - uvCoord.y, 7.0);\n  vec3 depthTint = color + vec3(smoothstep(0.0, 1.0, uvCoord.y));\n\n  float shadow = abs(uvCoord.x * 2.0 - 1.0) * 0.15;\n  \n  gl_FragColor = vec4(depthTint - vec3(shadow), alpha);\n}","vert.glsl":"varying vec3 vPos;\nvarying vec2 uvCoord;\n\nuniform float twist;\nuniform float skew;\nuniform float twistDir;\n\nuniform vec3 bulge;\n\nvoid main() {\n\n  uvCoord = uv;\n  vec4 vPos = modelViewMatrix * vec4(position, 1.0);\n  vPos.xyz += sin(uv.y * 3.14159) * bulge;\n  \n  vPos.xy *= 0.9 + abs(uv.x * 2.0 - 1.0) * 0.1;\n\n  gl_Position =  projectionMatrix * vPos;\n}"};
  var module = {};
  (function(){
    (function() {
  var Lattice, Spiral, Strut,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Lattice = (function(_super) {

    __extends(Lattice, _super);

    function Lattice() {
      Lattice.__super__.constructor.apply(this, arguments);
      this.flipped = [true, false].random();
      this.doubled = [true, false].random();
      this.spinSpeed = THREE.Math.randFloatSpread(180).degToRad;
      this.offsetTime = 10;
      this.bulge = new THREE.Vector3;
      this.animateTweens();
      this.position.z = 750;
      this.spiral1 = new Spiral(this, this.flipped);
      this.push(this.spiral1);
      if (this.doubled) {
        this.spiral2 = new Spiral(this, !this.flipped, this.spiral1);
        this.push(this.spiral2);
      }
    }

    Lattice.prototype.animateTweens = function() {
      var i, qty,
        _this = this;
      qty = THREE.Math.randInt(4, 12);
      this.offsetValues = {
        x: (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 0; 0 <= qty ? _i < qty : _i > qty; i = 0 <= qty ? ++_i : --_i) {
            _results.push(THREE.Math.randFloatSpread(10).degToRad);
          }
          return _results;
        })(),
        y: (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 0; 0 <= qty ? _i < qty : _i > qty; i = 0 <= qty ? ++_i : --_i) {
            _results.push(THREE.Math.randFloatSpread(10).degToRad);
          }
          return _results;
        })()
      };
      this.offsetValues.x.push(this.offsetValues.x[this.offsetValues.x.length - 1]);
      this.offsetValues.y.push(this.offsetValues.y[this.offsetValues.y.length - 1]);
      this.bulgevalues = {
        x: (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 0; _i < 4; i = ++_i) {
            _results.push(THREE.Math.randFloatSpread(75));
          }
          return _results;
        })(),
        y: (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 0; _i < 4; i = ++_i) {
            _results.push(THREE.Math.randFloatSpread(75));
          }
          return _results;
        })()
      };
      new TWEEN.Tween(this.rotation).to(this.offsetValues, this.offsetTime.ms).interpolation(TWEEN.Interpolation.CatmullRom).onComplete(function() {
        if (_this.active) {
          return _this.animateTweens();
        }
      }).start();
      return new TWEEN.Tween(this.bulge).to(this.bulgevalues, this.offsetTime.ms).interpolation(TWEEN.Interpolation.CatmullRom).start();
    };

    Lattice.prototype.update = function(elapsed) {
      Lattice.__super__.update.apply(this, arguments);
      return this.rotation.z += elapsed * this.spinSpeed;
    };

    return Lattice;

  })(Echotron.EchoStack);

  Spiral = (function(_super) {

    __extends(Spiral, _super);

    function Spiral(lattice, flipped, source) {
      var i;
      this.lattice = lattice;
      this.flipped = flipped;
      if (source == null) {
        source = {};
      }
      Spiral.__super__.constructor.apply(this, arguments);
      this.bulge = this.lattice.bulge;
      this.color = source.color || new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.6, 1));
      this.qty = source.qty || THREE.Math.randInt(3, 15);
      this.width = source.width || THREE.Math.randFloat(80, 300) / this.qty;
      this.twist = source.twist || THREE.Math.randFloat(2, 12);
      this.skew = source.skew || [1, 3].random();
      this.flippedDir = this.flipped ? -1 : 1;
      this.rotDirection = source.rotDirection || [1, -1].random();
      this.rotSpeedTarget = source.rotSpeedTarget || THREE.Math.randFloat(20, 50).degToRad;
      this.rotSpeedDecay = source.rotSpeedDecay || this.rotSpeedTarget * this.rotDirection * 8;
      this.rotSpeed = 0;
      this.push.apply(this, (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = this.qty; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(new Strut(this, i / this.qty, this.flipped));
        }
        return _results;
      }).call(this));
      this.position.z = -400 + this.rotDirection * 25;
    }

    Spiral.prototype.setSkew = function(skew) {
      var layer, _i, _len, _ref, _results;
      this.skew = skew;
      _ref = this.stack.layers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        _results.push(layer.skew = this.skew);
      }
      return _results;
    };

    Spiral.prototype.update = function(elapsed) {
      Spiral.__super__.update.apply(this, arguments);
      this.rotSpeed -= this.rotSpeedDecay * this.rotDirection * this.flippedDir * elapsed / stage.song.bps;
      if (this.rotSpeed > this.rotSpeedTarget * 3) {
        this.rotSpeed = this.rotSpeedTarget * 3;
      }
      if (this.rotSpeed < -this.rotSpeedTarget * 3) {
        this.rotSpeed = -this.rotSpeedTarget * 3;
      }
      return this.rotation.z += this.rotSpeed * this.rotDirection * elapsed / stage.song.bps;
    };

    Spiral.prototype.onBeat = function() {
      return this.rotSpeed = this.rotSpeedTarget;
    };

    return Spiral;

  })(Echotron.EchoStack);

  Strut = (function(_super) {

    __extends(Strut, _super);

    Strut.prototype.uniformAttrs = {
      color: 'c',
      twist: 'f',
      skew: 'f',
      twistDir: 'f',
      bulge: 'v3'
    };

    function Strut(spiral, angle, flipped) {
      var _ref;
      this.spiral = spiral;
      this.angle = angle;
      this.flipped = flipped;
      Strut.__super__.constructor.apply(this, arguments);
      this.angle *= 360..degToRad;
      this.widthScale = 0;
      _ref = this.spiral, this.color = _ref.color, this.twist = _ref.twist, this.skew = _ref.skew, this.bulge = _ref.bulge;
      this.twistDir = this.flipped ? -1 : 1;
      this.geom = new THREE.PlaneGeometry(this.spiral.width, 800, 1, 100);
      this.twistVertices();
      this.mesh = new THREE.Mesh(this.geom, new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        side: THREE.DoubleSide,
        fragmentShader: assets["frag.glsl"],
        vertexShader: assets['vert.glsl'],
        transparent: true,
        depthTest: false
      }));
      this.mesh.rotation.x = 90..degToRad;
      this.rotation.z = this.angle;
      this.add(this.mesh);
    }

    Strut.prototype.update = function(elapsed) {
      if (this.active) {
        this.widthScale += elapsed;
        if (this.widthScale > 1) {
          this.widthScale = 1;
        }
      } else {
        this.widthScale -= elapsed;
        if (this.widthScale < .001) {
          this.widthScale = .001;
        }
      }
      return this.scale.x = 1 - Math.pow(1 - this.widthScale, 2);
    };

    Strut.prototype.alive = function() {
      return this.widthScale > .001;
    };

    Strut.prototype.twistVertices = function() {
      var depth, swirl, vert, _i, _len, _ref, _results;
      _ref = this.geom.vertices;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vert = _ref[_i];
        depth = vert.y / 800 + 0.5;
        swirl = Math.pow(depth, this.skew) * this.twist * this.twistDir;
        vert.z = 80;
        _results.push(vert.set((vert.x * Math.cos(swirl) - vert.z * Math.sin(swirl)) * (1 - depth), vert.y, (vert.x * Math.sin(swirl) + vert.z * Math.cos(swirl)) * (1 - depth)));
      }
      return _results;
    };

    return Strut;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "lattice";
  window.Echotron.Echoes.midground.push(module.exports);
}());