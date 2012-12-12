(function() {
  var assets = {"frag.glsl":"uniform float inward;\nuniform float brightness;\nuniform float ease;\nuniform float ringSize;\nuniform float ringIntensity;\nuniform float fadeIn;\n\nuniform float ripples[12];\nuniform vec3 baseColor;\nuniform vec3 ringColor;\n\nuniform vec4 color;\nvarying vec3 vPos;\n\nvoid main() {\n  vec3 dimmedColor = baseColor * brightness;\n\n  float rings = 0.0;\n  for (int i = 0; i < 12; i++) {\n    float progress = pow(abs(inward - ripples[i]), ease);\n    float ringPos = abs(vPos.y / 1000.0 - progress);\n    float ringVal = 1.0 - smoothstep(0.0, 0.1 * ringSize, ringPos);\n    rings += clamp(ringVal * (ripples[i] * 0.85 + 0.3), 0.0, 1.0);\n  }\n\n  vec3 finalColor = dimmedColor + ringColor*rings*ringIntensity;\n  gl_FragColor = vec4(fadeIn * finalColor, 1.0);\n}","vert.glsl":"varying vec3 vPos;\n\nvoid main() {\n  // Pass to fragment shader\n  vPos = position;\n  \n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n}\n"};
  var module = {};
  (function(){
    (function() {
  var SingleTunnel, Tunnel,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Tunnel = (function(_super) {

    __extends(Tunnel, _super);

    function Tunnel() {
      var i, layer, _i, _ref;
      Tunnel.__super__.constructor.apply(this, arguments);
      for (i = _i = 0, _ref = THREE.Math.randInt(2, 4); 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        layer = new SingleTunnel;
        if (i !== 0) {
          layer.baseColor = new THREE.Color(0x000000);
        }
        this.push(layer);
      }
    }

    return Tunnel;

  })(Echotron.EchoStack);

  SingleTunnel = (function(_super) {

    __extends(SingleTunnel, _super);

    SingleTunnel.prototype.uniformAttrs = {
      inward: 'f',
      brightness: 'f',
      ripples: 'fv1',
      ease: 'f',
      ringSize: 'f',
      baseColor: 'c',
      ringColor: 'c',
      ringIntensity: 'f',
      fadeIn: 'f'
    };

    function SingleTunnel() {
      SingleTunnel.__super__.constructor.apply(this, arguments);
      this.inward = [1, 0].random();
      this.brightness = 1;
      this.ripples = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      this.fadeIn = 0;
      this.baseColor || (this.baseColor = new THREE.Color().setHSV(Math.random(), 0.5, THREE.Math.randFloat(0.5, 1)));
      this.ringColor = new THREE.Color().setHSV(Math.random(), THREE.Math.randFloat(0.6, 1.0), 1);
      this.spin = THREE.Math.randFloatSpread(180).rad;
      this.ringSize = THREE.Math.randFloat(0.2, 1.2);
      this.ringIntensity = THREE.Math.randFloat(0.05, 0.4);
      this.fadeSpeed = THREE.Math.randFloat(0.2, 0.5);
      this.fadeInTime = 3 / stage.song.bps;
      this.ease = [THREE.Math.randFloat(0.75, 1.2), THREE.Math.randFloat(1.2, 6)].random();
      this.sides = [40, [3, 4, 5, 6, 7].random()].random();
      this.mesh = new THREE.Mesh(new THREE.CylinderGeometry(0, THREE.Math.randFloat(150, 250), 2000, this.sides, 50), new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets["vert.glsl"],
        fragmentShader: assets["frag.glsl"],
        transparent: true,
        blending: THREE.AdditiveBlending
      }));
      this.mesh.material.side = THREE.BackSide;
      this.mesh.material.depthWrite = false;
      this.rotation.x = 90..rad;
      this.position.z = -60;
      this.add(this.mesh);
    }

    SingleTunnel.prototype.alive = function() {
      return this.brightness > 0 || _.max(this.ripples) > 0;
    };

    SingleTunnel.prototype.beat = function(beat) {
      this.ripples.unshift(1);
      return this.ripples = this.ripples.slice(0, 8);
    };

    SingleTunnel.prototype.bar = function(bar) {
      return this.brightness = 1;
    };

    SingleTunnel.prototype.update = function(elapsed) {
      var ripple;
      if (this.fadeIn < 1) {
        this.fadeIn += elapsed / this.fadeInTime;
      } else {
        this.fadeIn = 1;
      }
      this.ripples = (function() {
        var _i, _len, _ref, _results;
        _ref = this.ripples;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ripple = _ref[_i];
          ripple -= this.fadeSpeed * elapsed;
          if (ripple > 0) {
            _results.push(ripple);
          } else {
            _results.push(0);
          }
        }
        return _results;
      }).call(this);
      this.brightness -= 0.25 * elapsed;
      return this.mesh.rotation.y += this.spin * elapsed;
    };

    return SingleTunnel;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "tunnel";
  window.Echotron.Echoes.background.push(module.exports);
}());