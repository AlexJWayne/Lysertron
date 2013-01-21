(function() {
  var assets = {"frag.glsl":"uniform vec3 color;\n\nvarying vec3 vPos;\nvarying vec3 vNormal;\nvarying vec2 uvCoord;\n\nvoid main() {\n  float lightVal = smoothstep(0.45, 0.5, vNormal.y);\n  vec3 litColor = mix(vec3(lightVal), color, 0.7);\n  gl_FragColor = vec4(litColor, 1.0);\n}\n","vert.glsl":"varying vec3 vPos;\nvarying vec3 vNormal;\nvarying vec2 uvCoord;\n\nuniform float pulse;\nuniform float progress;\n\nvoid main() {\n  // Pass to fragment shader\n  vPos = position;\n  vNormal = (projectionMatrix * modelViewMatrix * vec4(normal, 1.0)).xyz;\n  uvCoord = uv;\n\n  //float growth = smoothstep(0.0, 0.2, clamp(progress, 0.0, 1.0));\n  //vec3 pulsed = position + normal * (1.0 - growth) * pulse;\n  //gl_Position = projectionMatrix * modelViewMatrix * vec4(pulsed, 1.0);\n\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n}\n"};
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
      this.animTime = THREE.Math.randFloat(2, 4) / stage.song.bps;
      this.thickness = [THREE.Math.randFloat(0.75, 2), THREE.Math.randFloat(0.75, 2)];
      this.thicknessCurve = [Curve.easeInSine, Curve.easeOutSine].random();
      this.stretch = [[THREE.Math.randFloat(0.3, 0.6), THREE.Math.randFloat(1.5, 3)].random(), [THREE.Math.randFloat(0.3, 0.6), THREE.Math.randFloat(1.5, 3)].random()];
      this.pulse = [THREE.Math.randFloat(1.0, 2.5), THREE.Math.randFloat(-0.5, -1.0)].random();
      this.color = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.5, 1));
      this.motionCurve = [TWEEN.Easing.Elastic.Out, TWEEN.Easing.Back.Out, TWEEN.Easing.Exponential.Out].random();
      if (this.motionCurve === TWEEN.Easing.Elastic.Out) {
        this.animTime *= 1.5;
      }
      this.fanAngle = THREE.Math.randFloat(10, 45).degToRad;
      this.radialDistance = THREE.Math.randFloat(3, 10);
      this.direction = 1;
      this.currentRing = this.direction === 1 ? 0 : 3;
      this.stack.push(new Ring(this, 10 + this.radialDistance * 0, 0), new Ring(this, 10 + this.radialDistance * 1, 1), new Ring(this, 10 + this.radialDistance * 2, 2), new Ring(this, 10 + this.radialDistance * 3, 3));
      this.tumble = new THREE.Vector3(THREE.Math.randFloatSpread(90).degToRad, THREE.Math.randFloatSpread(90).degToRad, THREE.Math.randFloatSpread(90).degToRad);
    }

    Gyro.prototype.onBeat = function() {
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
      var thickness, thicknessMix, _ref;
      this.gyro = gyro;
      this.radius = radius;
      this.ringIndex = ringIndex;
      Ring.__super__.constructor.apply(this, arguments);
      this.visible = true;
      _ref = this.gyro, this.animTime = _ref.animTime, this.pulse = _ref.pulse, this.color = _ref.color, this.motionCurve = _ref.motionCurve;
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
      this.progress = 0;
      return new TWEEN.Tween(this).to({
        progress: 1
      }, this.animTime.ms).easing(this.motionCurve).start();
    };

    Ring.prototype.kill = function() {
      var _this = this;
      Ring.__super__.kill.apply(this, arguments);
      return new TWEEN.Tween(this.scale).to({
        x: 0,
        y: 0,
        z: 0
      }, (1.5 / stage.song.bps + this.ringIndex / 4).ms).easing(TWEEN.Easing.Back.In).onComplete(function() {
        return _this.visible = false;
      }).start();
    };

    Ring.prototype.update = function(elapsed) {
      return this.mesh.rotation.x = this.progress * 180..degToRad;
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