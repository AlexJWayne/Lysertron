// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Layers.Cubes = (function(_super) {

    __extends(Cubes, _super);

    Cubes.prototype.components = {
      Rotator: {
        maxRoll: 90,
        maxPitch: 90
      }
    };

    function Cubes(scene) {
      this.scene = scene;
      Cubes.__super__.constructor.apply(this, arguments);
      this.cubes = [];
      this.size = [THREE.Math.randFloat(25, 200), THREE.Math.randFloat(25, 200)];
      this.spawnQty = THREE.Math.randInt(1, 6);
      this.shrinkTime = THREE.Math.randInt(3, 6) / this.scene.song.bps;
    }

    Cubes.prototype.beat = function() {
      var cube, i, _i, _ref;
      for (i = _i = 1, _ref = this.spawnQty; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        cube = new Layers.Cubes.Cube(this);
        this.add(cube);
        this.cubes.push(cube);
      }
    };

    Cubes.prototype.update = function(elapsed) {
      var cube, tempCubes, _i, _j, _len, _len1, _ref, _ref1;
      Cubes.__super__.update.apply(this, arguments);
      _ref = this.cubes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cube = _ref[_i];
        cube.update(elapsed);
      }
      tempCubes = [];
      _ref1 = this.cubes;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        cube = _ref1[_j];
        if (cube.expired) {
          this.remove(cube);
        } else {
          tempCubes.push(cube);
        }
      }
      return this.cubes = tempCubes;
    };

    Cubes.prototype.alive = function() {
      return this.cubes.length > 0;
    };

    return Cubes;

  })(Layers.Base);

  Layers.Cubes.Cube = (function(_super) {

    __extends(Cube, _super);

    function Cube(parent) {
      var material, size, _ref;
      Cube.__super__.constructor.apply(this, arguments);
      material = {};
      this.expired = false;
      this.uniforms = {
        beatScale: {
          type: 'f',
          value: 1
        }
      };
      size = (_ref = THREE.Math).randFloat.apply(_ref, parent.size);
      this.mesh = new THREE.Mesh(new THREE.CubeGeometry(size, size, size, 1, 1, 1), new THREE.ShaderMaterial(_.extend(this.getMatProperties('cube'), {
        uniforms: this.uniforms
      })));
      this.add(this.mesh);
      this.mesh.position.set(THREE.Math.randFloatSpread(500), THREE.Math.randFloatSpread(500), THREE.Math.randFloatSpread(500));
    }

    Cube.prototype.beat = function() {
      return this.uniforms.beatScale.value = 1;
    };

    Cube.prototype.update = function(elapsed) {
      Cube.__super__.update.apply(this, arguments);
      this.uniforms.beatScale.value -= elapsed / this.parent.shrinkTime;
      if (this.uniforms.beatScale.value <= 0) {
        return this.expired = true;
      }
    };

    return Cube;

  })(Layers.Base);

}).call(this);
