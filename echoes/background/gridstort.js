(function() {
  var assets = {"frag.glsl":"varying vec2 uvCoord;\n\nuniform float time;\nuniform float amplitude;\nuniform vec3 baseColor;\nuniform float density;\nuniform float opacity;\nuniform float speed;\nuniform float spinSpeed;\nuniform vec2 drift;\nuniform float intensity;\nuniform float birth;\nuniform float death;\n\nconst float UVSCALE = 10.0;\n\nvec2 ripple() {\n  vec2 normUV = (uvCoord - vec2(0.5)) * 2.0 * UVSCALE;\n\n  float distortion = (1.0 + cos(length(normUV) * intensity - time * speed));\n  float mainRipple = distortion * pow(amplitude, 3.0);\n\n  return normUV * mainRipple;\n}\n\nvoid main() {\n  vec2 coords = (uvCoord - vec2(0.5)) * UVSCALE;\n  vec2 theRipple = ripple();\n\n  // birth alpha\n  float alpha = birth / length(coords);\n  alpha = clamp(birth, 0.0, 1.0);\n\n  // death alpha\n  alpha *= (1.0 - death);\n\n  // Highlight\n  float highlight = dot(\n    vec3(cos(spinSpeed * time), sin(spinSpeed * time), 0.0),\n    normalize(vec3(theRipple, 1.0))\n  );\n\n  highlight = smoothstep(0.02, 0.2, abs(highlight)) * 0.6;\n\n  // Add ripple\n  coords = coords + theRipple;\n\n  // Spin\n  float spin = spinSpeed * time;\n  coords = vec2(\n    coords.x * cos(spin) - coords.y * sin(spin),\n    coords.x * sin(spin) + coords.y * cos(spin)\n  );\n\n  // Drift\n  coords += drift * time;\n\n  // Grid\n  float value = smoothstep(0.75, 0.85, abs(mod(coords.x, 1.0 / density) * density - 0.5) * 2.0);\n  value      -= smoothstep(0.75, 0.85, abs(mod(coords.y, 1.0 / density) * density - 0.5) * 2.0) * 0.75;\n\n  // Trough shadow\n  float shadow = length(theRipple) * 0.75;\n\n  //gl_FragColor = vec4(vec3(length(theRipple)), 1.0);\n  gl_FragColor = vec4(baseColor + vec3(value * opacity) - vec3(shadow) + vec3(highlight), alpha);\n}","vert.glsl":"varying vec2 uvCoord;\n\nvoid main() {\n  uvCoord = uv;\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);\n}"};
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
      intensity: 'f',
      birth: 'f',
      death: 'f'
    };

    function Gridstort() {
      Gridstort.__super__.constructor.apply(this, arguments);
      this.time = THREE.Math.randFloat(0, 10);
      this.amplitude = 0;
      this.amplitudeDir = 1;
      this.density = THREE.Math.randFloat(10, 30);
      this.opacityMax = THREE.Math.randFloat(0.05, 0.2);
      this.opacity = this.opacityMax;
      this.speed = THREE.Math.randFloat(5, 20);
      this.spinSpeed = THREE.Math.randFloatSpread(45).degToRad;
      this.intensity = THREE.Math.randFloat(15, 75);
      this.birth = 0;
      this.death = 0;
      this.drift = new THREE.Vector2(THREE.Math.randFloatSpread(0.3), THREE.Math.randFloatSpread(0.3));
      this.baseColor = new THREE.Color().setHSV(THREE.Math.randFloat(0, 1), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.3, 0.7));
      this.mesh = new THREE.Mesh(new THREE.PlaneGeometry(1750, 1750), new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets["vert.glsl"],
        fragmentShader: assets["frag.glsl"],
        depthTest: false
      }));
      this.add(this.mesh);
      this.rotation.x = THREE.Math.randFloat(-130, -210).degToRad;
    }

    Gridstort.prototype.onBeat = function() {
      return this.opacity = this.opacityMax;
    };

    Gridstort.prototype.onBar = function() {
      return this.amplitudeDir = 1;
    };

    Gridstort.prototype.update = function(elapsed) {
      this.birth += elapsed;
      this.time += elapsed;
      if (!this.active) {
        this.death += elapsed;
      }
      if (this.amplitudeDir === 1) {
        this.amplitude += elapsed * stage.song.bps * 4;
        if (this.amplitude > 1) {
          this.amplitude = 1;
          this.amplitudeDir = -1;
        }
      } else {
        this.amplitude -= (elapsed * stage.song.bps) / 4;
        if (this.amplitude < 0) {
          this.amplitude = 0;
        }
      }
      this.opacity -= this.opacityMax * elapsed * stage.song.bps * 0.65;
      if (this.opacity < 0.02) {
        this.opacity = 0.02;
      }
      return this.rotation.z += elapsed / 4.0;
    };

    Gridstort.prototype.alive = function() {
      return this.death < 1;
    };

    return Gridstort;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "gridstort";
  window.Echotron.Echoes.background.push(module.exports);
}());