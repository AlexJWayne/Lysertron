(function() {
  var assets = {"frag.glsl":"varying vec2 uvCoord;\n\nuniform float time;\nuniform float amplitude;\nuniform vec3 baseColor;\nuniform float density;\nuniform float opacity;\nuniform float speed;\nuniform float spinSpeed;\nuniform vec2 drift;\nuniform float intensity;\n\nvec2 ripple() {\n  vec2 normUV = (uvCoord - vec2(0.5)) * 2.0;\n\n  float len = length(normUV);\n  len = (1.0 + cos(len * intensity - time * speed));\n\n  return normUV * len * pow(amplitude, 3.0) * 0.75;\n}\n\nvoid main() {\n  vec2 coords = (uvCoord - vec2(0.5));\n\n  // Drift\n  coords += drift * time;\n\n  // Add ripple\n  vec2 theRipple = ripple();\n  coords = coords + theRipple;\n\n  // Spin\n  float spin = spinSpeed * time;\n  coords = vec2(\n    coords.x * cos(spin) - coords.y * sin(spin),\n    coords.x * sin(spin) + coords.y * cos(spin)\n  );\n\n  // Grid\n  float value = smoothstep(0.6, 1.0, abs(mod(coords.x, 1.0 / density) * density - 0.5) * 2.0);\n  value      -= smoothstep(0.6, 1.0, abs(mod(coords.y, 1.0 / density) * density - 0.5) * 2.0);\n\n  // Vertical Tint\n  vec3 tint = baseColor * pow(uvCoord.y, 4.0) * 3.0;\n\n  gl_FragColor = vec4(baseColor + tint + vec3(value * opacity) - vec3(length(theRipple) * 0.75), 1.0);\n}","vert.glsl":"varying vec2 uvCoord;\n\nvoid main() {\n  uvCoord = uv;\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n}"};
  var module = {};
  (function(){
    (function() {
  var Gridstort,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Gridstort = (function(_super) {

    __extends(Gridstort, _super);

    Gridstort.prototype.uniformAttrs = {
      time: 'f',
      amplitude: 'f',
      baseColor: 'c',
      density: 'f',
      opacity: 'f',
      speed: 'f',
      spinSpeed: 'f',
      drift: 'v2',
      intensity: 'f'
    };

    function Gridstort() {
      Gridstort.__super__.constructor.apply(this, arguments);
      this.time = THREE.Math.randFloat(0, 10);
      this.amplitude = 1;
      this.density = THREE.Math.randFloat(20, 60);
      this.opacityMax = THREE.Math.randFloat(0.15, 0.3);
      this.opacity = this.opacityMax;
      this.speed = THREE.Math.randFloat(5, 20);
      this.spinSpeed = THREE.Math.randFloatSpread(45).rad;
      this.intensity = THREE.Math.randFloat(10, 60);
      this.drift = new THREE.Vector2(THREE.Math.randFloatSpread(0.1), THREE.Math.randFloatSpread(0.1));
      this.baseColor = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.3, 0.7));
      this.mesh = new THREE.Mesh(new THREE.PlaneGeometry(175, 175), new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets["vert.glsl"],
        fragmentShader: assets["frag.glsl"]
      }));
      this.add(this.mesh);
      this.rotation.x = -180..rad;
    }

    Gridstort.prototype.beat = function() {
      return this.opacity = this.opacityMax;
    };

    Gridstort.prototype.bar = function() {
      return this.amplitude = 1;
    };

    Gridstort.prototype.update = function(elapsed) {
      this.time += elapsed;
      this.amplitude -= (elapsed * stage.song.bps) / 4;
      if (this.amplitude < 0) {
        this.amplitude = 0;
      }
      this.opacity -= this.opacityMax * elapsed * stage.song.bps * 0.85;
      if (this.opacity < 0) {
        return this.opacity = 0;
      }
    };

    return Gridstort;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "gridstort";
  window.Echotron.Echoes.background.push(module.exports);
}());