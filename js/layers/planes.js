// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Layers.Planes = (function(_super) {

    __extends(Planes, _super);

    Planes.prototype.components = {
      Rotator: {
        maxRoll: 45,
        maxPitch: 15
      }
    };

    function Planes(scene) {
      var plane, _i, _len, _ref;
      this.scene = scene;
      Planes.__super__.constructor.apply(this, arguments);
      this.height = THREE.Math.randFloat(250, 500);
      this.deathSpeed = 500;
      this.angle = 0;
      this.maxDrift = 300;
      this.decayCoef = THREE.Math.randFloat(0.5, 1.0);
      this.drift = {
        angle: Curve.low(Math.random()) * 60 * Math.PI / 180,
        r: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)],
        g: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)],
        b: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)]
      };
      this.gridSize = {
        r: THREE.Math.randFloat(75, 600),
        g: THREE.Math.randFloat(75, 600),
        b: THREE.Math.randFloat(75, 600)
      };
      this.planes = [
        new Layers.Planes.Plane(this, {
          side: THREE.FrontSide
        }), new Layers.Planes.Plane(this, {
          side: THREE.BackSide
        })
      ];
      _ref = this.planes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plane = _ref[_i];
        this.add(plane);
      }
      this.planes[0].mesh.rotation.x = 90 * (Math.PI / 180);
      this.planes[0].mesh.position.y = this.height;
      this.planes[1].mesh.rotation.x = 90 * (Math.PI / 180);
      this.planes[1].mesh.position.y = -this.height;
    }

    Planes.prototype.bar = function() {
      var plane, _i, _len, _ref, _results;
      _ref = this.planes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plane = _ref[_i];
        _results.push(plane.beat());
      }
      return _results;
    };

    Planes.prototype.update = function(elapsed) {
      var plane, _i, _len, _ref, _results;
      Planes.__super__.update.apply(this, arguments);
      _ref = this.planes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plane = _ref[_i];
        _results.push(plane.update(elapsed));
      }
      return _results;
    };

    return Planes;

  })(Layers.Base);

  Layers.Planes.Plane = (function(_super) {

    __extends(Plane, _super);

    function Plane(owner, _arg) {
      this.owner = owner;
      this.side = _arg.side;
      Plane.__super__.constructor.apply(this, arguments);
      this.uniforms = {
        brightness: {
          type: 'f',
          value: 1
        },
        angle: {
          type: 'f',
          value: 0
        },
        shiftXr: {
          type: 'f',
          value: 0
        },
        shiftYr: {
          type: 'f',
          value: 0
        },
        shiftXg: {
          type: 'f',
          value: 0
        },
        shiftYg: {
          type: 'f',
          value: 0
        },
        shiftXb: {
          type: 'f',
          value: 0
        },
        shiftYb: {
          type: 'f',
          value: 0
        },
        gridSizeR: {
          type: 'f',
          value: this.owner.gridSize.r
        },
        gridSizeG: {
          type: 'f',
          value: this.owner.gridSize.g
        },
        gridSizeB: {
          type: 'f',
          value: this.owner.gridSize.b
        }
      };
      this.mesh = new THREE.Mesh(new THREE.PlaneGeometry(100000, 100000), new THREE.ShaderMaterial(_.extend(this.getMatProperties('plane'), {
        uniforms: this.uniforms,
        side: this.side,
        transparent: true,
        blending: THREE.AdditiveBlending,
        blendEquation: THREE.AddEquation
      })));
      this.mesh.doubleSided = true;
      this.mesh.transparent = true;
      this.add(this.mesh);
    }

    Plane.prototype.beat = function() {
      return this.uniforms.brightness.value = 1;
    };

    Plane.prototype.update = function(elapsed) {
      var decay;
      decay = this.parent.scene.song.bps * this.owner.decayCoef / this.parent.scene.song.data.track.time_signature;
      this.uniforms.brightness.value -= decay * elapsed;
      if (this.uniforms.brightness.value < 0) {
        this.uniforms.brightness.value = 0;
      }
      this.uniforms.angle.value += this.parent.drift.angle * elapsed * (this.uniforms.brightness.value - 0.5) * 2;
      this.uniforms.shiftXr.value += this.parent.drift.r[0] * this.parent.maxDrift * elapsed;
      this.uniforms.shiftXr.value += this.parent.drift.r[0] * this.parent.maxDrift * elapsed;
      this.uniforms.shiftYr.value += this.parent.drift.r[1] * this.parent.maxDrift * elapsed;
      this.uniforms.shiftXg.value -= this.parent.drift.g[0] * this.parent.maxDrift * elapsed;
      this.uniforms.shiftYg.value += this.parent.drift.g[1] * this.parent.maxDrift * elapsed;
      this.uniforms.shiftXb.value -= this.parent.drift.b[0] * this.parent.maxDrift * elapsed;
      return this.uniforms.shiftYb.value += this.parent.drift.b[1] * this.parent.maxDrift * elapsed;
    };

    return Plane;

  })(Layers.Base);

}).call(this);
