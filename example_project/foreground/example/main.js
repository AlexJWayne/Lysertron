//
// Vanilla javascript version of the example forground layer.
// Delete main.coffee to use vanilla JavaScript
// Or delete this file to use CoffeeScript
//



// Inherit from Layer or LayerStack.
var Example = Lysertron.Layer.extend();

// The class that is your layer needs to be assigned to module.exports in node.js style.
module.exports = Example;

// Allows shorthand property setters to be passed as uniforms to the shaders.
//
// This:
//   this.baseColor.setRGB(1,1,1);
//
// Is now equivalent to this:
//   this.uniforms.baseColor.value.setRGB(1,1,1);
//
// And now you can simply pass @uniforms to the THREE.ShaderMaterial and access
// `baseColor` as a uniform within the shader.
Example.prototype.uniformAttrs = {
  baseColor: 'c'
};

// Setup up the layer. Called for you when the layer is created.
Example.prototype.initialize = function () {

  // Sets the value for the unirformAttr declared above.
  this.baseColor = new THREE.Color(0xffffff);

  // Make a mesh that is a simple cube.
  this.mesh = new THREE.Mesh(
    new THREE.CubeGeometry(10, 10, 10),

    // Shaders are awesome. Use em!
    new THREE.ShaderMaterial({

      // @uniforms is provided by uniformAttrs above.
      uniforms: this.uniforms,

      // Load shaders from the magic `assets` object.
      vertexShader:   assets['vert.glsl'],
      fragmentShader: assets['frag.glsl']
    })
  );
  
  // Add the cube mesh to the layer.
  this.add(this.mesh);
};

// Called per frame, update the objects in the layer however you want.
// `elapsed` is the time in seconds since the last frame.
Example.prototype.update = function (elapsed) {

  // In this case, spin the cube on each axis at 1 radian per second.
  this.mesh.rotation.x += elapsed;
  this.mesh.rotation.y += elapsed;
  this.mesh.rotation.z += elapsed;
};

// Called on every beat of the song.  Use it to change state to show it
// reacting to the beat.
Example.prototype.onBeat = function (beat) {
  return this.baseColor.setRGB(Math.random(), Math.random(), Math.random());
};

// // Called for each discernable note. Inspect the argment for details about the note.
// Example.prototype.onSegment = function(segment) { };

// // Called at the start of every bar. Typically 4 beats in a 4/4 time signature.
// Example.prototype.onBar = function(bar) { };

// // Called on each tatum. Tatums represent the lowest regular pulse train that a
// // listener intuitively infers from the timing of perceived musical events (segments).
// Example.prototype.onTatum = function(tatum) { };

// // Called when the scene transitions and the layer should begin to die.  If you
// // override this, make sure to call `super`!
// Example.prototype.kill = function() {
//   Lysertron.Layer.prototype.kill.apply(this);
// };

// // Called every frame after the layer has been killed. For as long as this method
// // returns `true` the layer will still be rendered. Make it return false when it's
// // death animation is completed.
// Example.prototype.alive = function() { };
