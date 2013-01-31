(function() {
  var assets = {"frag.glsl":"uniform vec3 baseColor;\nuniform float darkening;\n\nvarying float age;\n\nvoid main() {\n  float distance = length(gl_PointCoord - vec2(0.5)) * 2.0;\n  float alphaCircle = 1.0 - distance;\n  float core = smoothstep(0.2, 0.0, distance);\n  float darken = smoothstep(0.2, 1.0, age);\n\n  gl_FragColor = vec4(\n    (baseColor + vec3(age * 1.5 - core)) * pow(age, darkening),\n    alphaCircle * age\n  );\n}","vert.glsl":"attribute float energy;\n\nvarying float age;\n\nvoid main() {\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n\n  age = energy;\n\n  float fl = 40.0;\n  float scale = fl / (fl + gl_Position.z);\n  gl_PointSize = 100.0 * scale;\n}"};
  var module = {};
  (function(){
    (function() {
  var Gravity, MirrorPointZone, Resistance, Sparkler, SphereZone, hideVector,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  hideVector = function(v) {
    return v.set(0, 0, 0);
  };

  MirrorPointZone = (function() {

    function MirrorPointZone(pos) {
      this.pos = pos;
    }

    MirrorPointZone.prototype.getLocation = function() {
      var which;
      which = [1, -1].random();
      return SPARKS.VectorPool.get().copy(this.pos).multiplyScalar(which);
    };

    return MirrorPointZone;

  })();

  SphereZone = (function() {

    function SphereZone(x, y, z, maxr) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.maxr = maxr;
    }

    SphereZone.prototype.getLocation = function() {
      var v;
      v = SPARKS.VectorPool.get().set(1, 1, 1);
      while (!(v.length() <= 1)) {
        v.set(THREE.Math.randFloatSpread(-1, 1), THREE.Math.randFloatSpread(-1, 1), THREE.Math.randFloatSpread(-1, 1));
      }
      return v.setLength(this.maxr);
    };

    return SphereZone;

  })();

  Resistance = (function() {

    function Resistance(amount) {
      this.amount = amount;
    }

    Resistance.prototype.update = function(emitter, particle, time) {
      var amount, v;
      v = particle.velocity;
      if (v.length() === 0) {
        return;
      }
      amount = this.amount * time;
      if (amount < v.length()) {
        return v.setLength(v.length() - amount);
      } else {
        return v.setLength(0);
      }
    };

    return Resistance;

  })();

  Gravity = (function() {

    function Gravity(force) {
      this.force = force;
    }

    Gravity.prototype.update = function(emitter, particle, time) {
      var influence;
      influence = particle.position.length() / 100;
      return particle.velocity.subSelf(THREE.Vector3.temp(particle.position).setLength(this.force * time / influence));
    };

    return Gravity;

  })();

  module.exports = Sparkler = (function(_super) {

    __extends(Sparkler, _super);

    Sparkler.prototype.uniformAttrs = {
      baseColor: 'c',
      darkening: 'f'
    };

    function Sparkler() {
      this.onParticleDead = __bind(this.onParticleDead, this);

      this.onParticleCreated = __bind(this.onParticleCreated, this);

      var i, _i;
      Sparkler.__super__.constructor.apply(this, arguments);
      this.setupValues();
      this.vertexAttributes = {
        energy: {
          type: 'f',
          value: []
        }
      };
      this.lastParticleIndex = 0;
      this.geom = new THREE.Geometry;
      for (i = _i = 0; _i < 6000; i = ++_i) {
        this.geom.vertices.push(new THREE.Vector3(0, 0, 0));
        this.vertexAttributes.energy.value.push(0);
      }
      this.particlesPerBeat = 1500;
      this.particlesPerSegment = 20;
      this.counter = new SPARKS.ShotCounter(this.particlesPerBeat);
      this.emitter = new SPARKS.Emitter(this.counter);
      this.emitterZone = new MirrorPointZone(new THREE.Vector3(0, 0, 0));
      this.emitter.addInitializer(new SPARKS.Position(this.emitterZone));
      this.emitter.addInitializer(new SPARKS.Velocity(new SphereZone(0, 0, 0, 50)));
      this.emitter.addInitializer(new SPARKS.Lifetime(.2, 1.5));
      this.emitter.addAction(new SPARKS.Age);
      this.emitter.addAction(new SPARKS.RandomDrift(this.drift, this.drift, this.drift));
      this.emitter.addAction(new SPARKS.Move);
      this.emitter.addAction(new Resistance(40));
      this.emitter.addAction(new Gravity(30));
      this.emitter.addCallback("created", this.onParticleCreated);
      this.emitter.addCallback("dead", this.onParticleDead);
      this.particles = new THREE.ParticleSystem(this.geom, new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        attributes: this.vertexAttributes,
        vertexShader: assets['vert.glsl'],
        fragmentShader: assets['frag.glsl'],
        transparent: true,
        depthTest: false
      }));
      this.particles.sortParticles = true;
      this.add(this.particles);
      this.queuePositionAnimation();
      this.emitter.start();
    }

    Sparkler.prototype.setupValues = function() {
      this.drift = THREE.Math.randFloat(0, 500);
      this.baseColor = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), 0.9, 1);
      return this.darkening = THREE.Math.randFloat(0.5, 3);
    };

    Sparkler.prototype.onParticleCreated = function(p) {
      if (this.emitter._particles.length > this.geom.vertices.length) {
        console.log("Exceeded Particle max! " + this.emitter._particles.length);
      }
      if (this.lastParticleIndex >= this.geom.vertices.length) {
        this.lastParticleIndex = 0;
      }
      return p.target = this.lastParticleIndex++;
    };

    Sparkler.prototype.onParticleDead = function(p) {
      hideVector(this.geom.vertices[p.target]);
      return this.vertexAttributes.energy.value[p.target] = 0;
    };

    Sparkler.prototype.queuePositionAnimation = function() {
      var i, pos, positions, zone, _i;
      zone = new SphereZone(0, 0, 0, 30);
      positions = {
        x: [],
        y: [],
        z: []
      };
      for (i = _i = 0; _i < 10; i = ++_i) {
        pos = zone.getLocation();
        positions.x.push(pos.x);
        positions.y.push(pos.y);
        positions.z.push(pos.z);
      }
      this.emitterZone.pos.copy(zone.getLocation());
      return new TWEEN.Tween(this.emitterZone.pos).to(positions, 20..ms).interpolation(TWEEN.Interpolation.CatmullRom).start();
    };

    Sparkler.prototype.update = function(elapsed) {
      var p, _i, _len, _ref, _results;
      Sparkler.__super__.update.apply(this, arguments);
      _ref = this.emitter._particles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        this.geom.vertices[p.target].copy(p.position);
        _results.push(this.vertexAttributes.energy.value[p.target] = p.energy);
      }
      return _results;
    };

    Sparkler.prototype.onBeat = function() {
      this.counter.particles = this.particlesPerBeat;
      return this.counter.used = false;
    };

    Sparkler.prototype.onSegment = function() {
      if (this.counter.used) {
        this.counter.particles = this.particlesPerSegment;
        return this.counter.used = false;
      }
    };

    Sparkler.prototype.alive = function() {
      return this.emitter._particles.length > 0;
    };

    return Sparkler;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "sparklers";
  window.Echotron.Echoes.foreground.push(module.exports);
}());