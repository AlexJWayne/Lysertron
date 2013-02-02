# The Class that is your layer needs to be assigned
# to module.exports in node.js style.
module.exports = class Example extends Echotron.Echo

  # Allows shorthand property setters to be passed as
  # uniforms to the shaders.
  uniformAttrs:
    baseColor: 'c'

  # Setup up the layer. Called for you when the layer is created.
  initialize: ->

    # Sets the value for the unirformAttr decalred above.
    @baseColor = new THREE.Color(0xffffff)

    # Make a mesh that is a simple cube.
    @mesh = new THREE.Mesh(
      new THREE.CubeGeometry(10, 10, 10)

      # Shaders are awesome. Textures are for wimps :P
      new THREE.ShaderMaterial(

        # @uniforms is provided by uniformAttrs above.
        uniforms:       @uniforms

        # Load shaders from the magic `assets` object.
        vertexShader:   assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
      )
    )

    # Add the cube mesh to the layer.
    @add @mesh

  # Called per frame, update the objects in the layer however you want.
  update: (elapsed) ->

    # In this case, spin the cube on each axis at 1 radian per second.
    @mesh.rotation.x += elapsed
    @mesh.rotation.y += elapsed
    @mesh.rotation.z += elapsed

  # Called on every beat of the song.  Use it to change state to show it
  # reacting to the beat.
  onBeat: ->

    # In this case, set the cube to a random color.
    @baseColor.setRGB(
      Math.random(), Math.random(), Math.random()
    )
