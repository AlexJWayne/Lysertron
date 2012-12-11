(function() {
  var assets = {"frag.glsl":"varying vec2 uvCoord;\nvarying vec3 vPos;\n\nuniform vec3 color;\n\nvoid main() {\n  float alpha = 1.0 - pow(1.0 - uvCoord.y, 6.0);\n  vec3 depthTint = color + vec3(smoothstep(0.0, 1.0, uvCoord.y));\n  gl_FragColor = vec4(depthTint, alpha);\n}","vert.glsl":"varying vec3 vPos;\nvarying vec2 uvCoord;\n\nuniform float twist;\nuniform float skew;\nuniform float twistDir;\n\nvoid main() {\n  // Pass to fragment shader\n  vec3 transPos = (modelViewMatrix * vec4(position, 1.0)).xyz;\n  uvCoord = uv;\n\n  float depth = uv.y;\n  float swirl = pow(depth, skew) * twist * twistDir;\n\n  vec3 twisted = vec3(\n    (transPos.x * cos(swirl) - transPos.y * sin(swirl)) * (1.0 - depth),\n    (transPos.x * sin(swirl) + transPos.y * cos(swirl)) * (1.0 - depth),\n    transPos.z + twistDir\n  );\n\n  gl_Position =  projectionMatrix * vec4(twisted, 1.0);\n}\n"};
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
      this.spiral1 = new Spiral(this.flipped);
      this.push(this.spiral1);
      if (this.doubled) {
        this.spiral2 = new Spiral(!this.flipped, this.spiral1);
        this.push(this.spiral2);
      }
    }

    return Lattice;

  })(Echotron.EchoStack);

  Spiral = (function(_super) {

    __extends(Spiral, _super);

    function Spiral(flipped, source) {
      var i;
      this.flipped = flipped;
      if (source == null) {
        source = {};
      }
      Spiral.__super__.constructor.apply(this, arguments);
      this.color = source.color || new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.6, 1));
      this.qty = source.qty || THREE.Math.randInt(5, 12);
      this.width = source.width || THREE.Math.randFloat(80, 200) / this.qty;
      this.twist = source.twist || THREE.Math.randFloat(2, 12);
      this.skew = source.skew || [1, 3].random();
      this.flippedDir = this.flipped ? -1 : 1;
      this.rotDirection = source.rotDirection || [1, -1].random();
      this.rotSpeedTarget = source.rotSpeedTarget || THREE.Math.randFloat(20, 75).rad;
      this.rotSpeedDecay = source.rotSpeedDecay || this.rotSpeedTarget * THREE.Math.randFloat(3, 9);
      this.rotSpeed = 0;
      this.push.apply(this, (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = this.qty; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(new Strut(this, i / this.qty, this.flipped));
        }
        return _results;
      }).call(this));
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
      return this.rotation.z += this.rotSpeed * this.rotDirection * elapsed / stage.song.bps;
    };

    Spiral.prototype.beat = function() {
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
      twistDir: 'f'
    };

    function Strut(lattice, angle, flipped) {
      var _ref;
      this.lattice = lattice;
      this.angle = angle;
      this.flipped = flipped;
      Strut.__super__.constructor.apply(this, arguments);
      this.angle *= 360..rad;
      _ref = this.lattice, this.color = _ref.color, this.twist = _ref.twist, this.skew = _ref.skew;
      this.twistDir = this.flipped ? -1 : 1;
      this.mesh = new THREE.Mesh(new THREE.PlaneGeometry(this.lattice.width, 800, 1, 100), new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        side: THREE.BackSide,
        fragmentShader: assets["frag.glsl"],
        vertexShader: assets['vert.glsl'],
        transparent: true,
        depthTest: false
      }));
      this.mesh.rotation.x = 90..rad;
      this.rotation.z = this.angle;
      this.mesh.position.z = 400;
      this.mesh.position.y = -60;
      this.add(this.mesh);
    }

    return Strut;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "lattice";
  window.Echotron.Echoes.midground.push(module.exports);
}());