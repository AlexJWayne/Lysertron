(function() {
  var assets = {"frag.glsl":"uniform vec3 color;\n\nvarying vec3 vPos;\nvarying vec3 vNormal;\nvarying vec2 uvCoord;\n\nvoid main() {\n  float lightVal = smoothstep(0.45, 0.5, vNormal.y);\n  vec3 litColor = mix(vec3(lightVal), color, 0.7);\n  gl_FragColor = vec4(litColor, 1.0);\n}\n","vert.glsl":"varying vec3 vPos;\nvarying vec3 vNormal;\nvarying vec2 uvCoord;\n\nuniform float pulse;\nuniform float progress;\n\nvoid main() {\n  // Pass to fragment shader\n  vPos = position;\n  vNormal = (projectionMatrix * modelViewMatrix * vec4(normal, 1.0)).xyz;\n  uvCoord = uv;\n\n  float growth = smoothstep(0.0, 0.2, clamp(progress, 0.0, 1.0));\n  vec3 pulsed = position + normal * (1.0 - growth) * pulse;\n\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(pulsed, 1.0);\n}\n"};
  var module = {};
  (function(){
    (function() {
  var Gyro, Ring,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Gyro = (function(_super) {

    __extends(Gyro, _super);

    function Gyro() {
      Gyro.__super__.constructor.apply(this, arguments);
      this.animTime = THREE.Math.randFloat(1, 2.5) / stage.song.bps;
      this.thickness = [THREE.Math.randFloat(0.75, 2), THREE.Math.randFloat(0.75, 2)];
      this.thicknessCurve = [Curve.easeInSine, Curve.easeOutSine].random();
      this.stretch = [[THREE.Math.randFloat(0.3, 0.6), THREE.Math.randFloat(1.5, 3)].random(), [THREE.Math.randFloat(0.3, 0.6), THREE.Math.randFloat(1.5, 3)].random()];
      this.pulse = [THREE.Math.randFloat(1.0, 2.5), THREE.Math.randFloat(-0.5, -1.0)].random();
      this.color = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.5, 1));
      this.fanAngle = THREE.Math.randFloat(10, 45).rad;
      this.radialDistance = THREE.Math.randFloat(3, 10);
      this.direction = 1;
      this.currentRing = this.direction === 1 ? 0 : 3;
      this.stack.push(new Ring(this, 10 + this.radialDistance * 0, 0), new Ring(this, 10 + this.radialDistance * 1, 1), new Ring(this, 10 + this.radialDistance * 2, 2), new Ring(this, 10 + this.radialDistance * 3, 3));
      this.tumble = new THREE.Vector3(THREE.Math.randFloatSpread(90).rad, THREE.Math.randFloatSpread(90).rad, THREE.Math.randFloatSpread(90).rad);
    }

    Gyro.prototype.beat = function() {
      var layer;
      layer = this.stack.layers[this.currentRing];
      this.add(layer);
      layer.nudge();
      this.currentRing += this.direction;
      if (this.currentRing >= this.stack.layers.length) {
        this.currentRing = 0;
      }
      if (this.currentRing < 0) {
        return this.currentRing = this.stack.layers.length - 1;
      }
    };

    Gyro.prototype.update = function(elapsed) {
      Gyro.__super__.update.apply(this, arguments);
      return this.rotation.addSelf(THREE.Vector3.temp(this.tumble).multiplyScalar(elapsed));
    };

    return Gyro;

  })(Echotron.EchoStack);

  Ring = (function(_super) {

    __extends(Ring, _super);

    Ring.prototype.uniformAttrs = {
      progress: 'f',
      pulse: 'f',
      color: 'c'
    };

    function Ring(gyro, radius, ringIndex) {
      var thickness, thicknessMix;
      this.gyro = gyro;
      this.radius = radius;
      this.ringIndex = ringIndex;
      Ring.__super__.constructor.apply(this, arguments);
      this.animTime = this.gyro.animTime;
      this.pulse = this.gyro.pulse;
      this.visible = true;
      this.color = this.gyro.color;
      this.rotation.z = this.gyro.fanAngle * this.ringIndex;
      thicknessMix = this.gyro.thicknessCurve(this.ringIndex / 3);
      thickness = this.gyro.thickness[0] * (1 - thicknessMix) + this.gyro.thickness[1] * thicknessMix;
      this.add(this.mesh = new THREE.Mesh(new THREE.TorusGeometry(this.radius, thickness, 10, 60), new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        fragmentShader: assets['frag.glsl'],
        vertexShader: assets['vert.glsl']
      })));
    }

    Ring.prototype.nudge = function() {
      return this.lastNudgeAt = Date.now() / 1000;
    };

    Ring.prototype.update = function(elapsed) {
      var shrinkAmount, sinceNudge;
      sinceNudge = new Date().getTime() / 1000 - this.lastNudgeAt;
      this.progress = sinceNudge / this.animTime;
      if (sinceNudge < this.animTime) {
        this.mesh.rotation.x = Tween.easeOutSine(sinceNudge, 0, 180..rad, this.animTime);
      } else {
        this.mesh.rotation.x = 0;
      }
      if (!this.active) {
        shrinkAmount = elapsed / stage.song.bps;
        if (shrinkAmount < this.scale.length() && this.scale.x > 0) {
          return this.scale.subSelf(THREE.Vector3.temp(shrinkAmount));
        } else {
          this.scale.set(.001, .001, .001);
          return this.visible = false;
        }
      }
    };

    Ring.prototype.kill = function() {
      return Ring.__super__.kill.apply(this, arguments);
    };

    Ring.prototype.alive = function() {
      return this.visible;
    };

    return Ring;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "gyro";
  window.Echotron.Echoes.foreground.push(module.exports);
}());