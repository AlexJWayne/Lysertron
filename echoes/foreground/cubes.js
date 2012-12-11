(function() {
  var assets = {"bright.fshader":"uniform float beatScale;\nuniform vec4 color;\n\nvarying vec3 vPos;\n\nuniform vec3 tint;\n\nvoid main() {\n\n  vec3 normPos = normalize(vPos)/6.0 + tint;\n  \n  vec3 lightness = vec3(1.0)        * pow(beatScale, 2.5);\n  vec3 darkness  = vec3(0.0) * (1.0 - pow(beatScale, 2.0));\n\n  gl_FragColor = vec4(normPos + lightness - darkness*2.0, 1.0);\n\n}\n","lit.fshader":"uniform float beatScale;\nuniform vec4 color;\nuniform vec3 tint;\n\nvarying vec3 vPos;\nvarying vec3 vNormal;\n\nvoid main() {\n\n  vec3 light = vec3(0.5, 0.2, 1.0);\n  vec3 litColor = tint * max(0.0, dot(vNormal, light));\n  \n  vec3 lightness = vec3(1.0) * pow(beatScale, 2.5);\n\n  gl_FragColor = vec4(litColor + lightness, 1.0);\n\n}\n","scaler.vshader":"uniform float beatScale;\n\nvarying vec3 vPos;\nvarying vec3 vNormal;\n\nvoid main() {\n  // Pass to fragment shader\n  vPos = position;\n  vNormal = normal;\n\n  vec3 scaledPos = vPos * beatScale * beatScale;\n\n  gl_Position = projectionMatrix * modelViewMatrix * vec4(scaledPos, 1.0);\n}\n"};
  var module = {};
  (function(){
    (function() {
  var Cube, Cubes,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  module.exports = Cubes = (function(_super) {

    __extends(Cubes, _super);

    function Cubes() {
      var direction;
      Cubes.__super__.constructor.apply(this, arguments);
      this.size = [THREE.Math.randFloat(3, 8), THREE.Math.randFloat(3, 8)];
      this.type = 'Cube';
      this.shader = ['lit', 'bright'].random();
      this.spawnQty = THREE.Math.randInt(3, 8);
      this.shrinkTime = THREE.Math.randInt(3, 6) / stage.song.bps;
      direction = [1, -1].random();
      this.speed = THREE.Math.randFloat(20, 50) * -direction;
      this.accel = THREE.Math.randFloat(50, 100) * direction;
      this.roll = [0, THREE.Math.randFloatSpread(180)].random().rad;
      this.tumble = [0, THREE.Math.randFloatSpread(90)].random().rad;
      this.rotation.x = THREE.Math.randFloat(0, 360).rad;
      this.rotation.y = THREE.Math.randFloat(0, 360).rad;
      this.rotation.z = THREE.Math.randFloat(0, 360).rad;
      this.color = new THREE.Color().setHSV(Math.random(), THREE.Math.randFloat(0.5, 1), Math.random());
    }

    Cubes.prototype.beat = function() {
      var i, _i, _ref;
      for (i = _i = 1, _ref = this.spawnQty; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        this.push(new Cube(this, {
          color: this.color,
          speed: this.speed,
          accel: this.accel,
          size: this.size
        }));
      }
    };

    Cubes.prototype.bar = function() {
      var i, _i, _ref, _results;
      _results = [];
      for (i = _i = 1, _ref = this.spawnQty * 5; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        _results.push(this.push(new Cube(this, {
          color: this.color,
          speed: Math.abs(this.speed * 2),
          accel: this.accel,
          size: this.size.map(function(s) {
            return s / 3;
          })
        })));
      }
      return _results;
    };

    Cubes.prototype.update = function(elapsed) {
      Cubes.__super__.update.apply(this, arguments);
      this.rotation.z += this.roll * elapsed;
      return this.rotation.x += this.tumble * elapsed;
    };

    return Cubes;

  })(Echotron.EchoStack);

  Cube = (function(_super) {

    __extends(Cube, _super);

    Cube.prototype.uniformAttrs = {
      beatScale: 'f',
      tint: 'c'
    };

    function Cube(parentLayer, _arg) {
      var geom, _ref;
      this.parentLayer = parentLayer;
      this.color = _arg.color, this.speed = _arg.speed, this.accel = _arg.accel, this.size = _arg.size;
      Cube.__super__.constructor.apply(this, arguments);
      this.beatScale = 1;
      this.tint = this.color;
      size = (_ref = THREE.Math).randFloat.apply(_ref, this.size);
      geom = this.parentLayer.type === 'Cube' ? new THREE.CubeGeometry(size, size, size, 1, 1, 1) : new THREE.SphereGeometry(size / 2, 16, 12);
      this.mesh = new THREE.Mesh(geom, new THREE.ShaderMaterial({
        uniforms: this.uniforms,
        vertexShader: assets["scaler.vshader"],
        fragmentShader: assets["" + this.parentLayer.shader + ".fshader"]
      }));
      this.add(this.mesh);
      this.mesh.position.set(THREE.Math.randFloatSpread(30), THREE.Math.randFloatSpread(30), THREE.Math.randFloatSpread(30));
      this.accel = this.accel;
      this.vel = this.mesh.position.clone().setLength(this.speed);
    }

    Cube.prototype.alive = function() {
      return this.uniforms.beatScale.value > 0;
    };

    Cube.prototype.update = function(elapsed) {
      this.beatScale -= elapsed / this.parentLayer.shrinkTime;
      this.vel.addSelf(THREE.Vector3.temp(this.mesh.position).setLength(this.accel * elapsed));
      this.mesh.position.addSelf(THREE.Vector3.temp(this.vel).multiplyScalar(elapsed));
      if (this.beatScale <= 0) {
        return this.kill();
      }
    };

    return Cube;

  })(Echotron.Echo);

}).call(this);

  }.call({}));
  module.exports.id = "cubes";
  window.Echotron.Echoes.foreground.push(module.exports);
}());