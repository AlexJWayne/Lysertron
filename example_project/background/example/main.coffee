# The class that is your layer needs to be assigned to module.exports in node.js style.
module.exports = class Example extends Lysertron.Layer
  # Allows shorthand property setters to be passed as uniforms to the shaders.
  #
  # This:
  #   @baseColor.setRGB(1,1,1)
  #
  # Is now equivalent to this:
  #   @uniforms.baseColor.value.setRGB(1,1,1)
  #
  # And now you can simply pass @uniforms to the THREE.ShaderMaterial and access
  # `baseColor` as a uniform within the shader.
  uniformAttrs:
    baseColor: 'c'

  # Setup up the layer. Called for you when the layer is created.
  initialize: ->

    # Sets the value for the unirformAttr declared above.
    @baseColor = new THREE.Color(0xffffff)

    # Make a mesh that is a simple plane.
    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(200, 200)

      # Shaders are awesome. Textures are for wimps :P
      new THREE.ShaderMaterial(

        # @uniforms is provided by uniformAttrs above.
        uniforms:       @uniforms

        # Load shaders from the magic `assets` object.
        vertexShader:   assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
      )
    )

    # Flip the plane so the renderable side faces teh camera.
    @rotation.x = -180.degToRad

    # Add the plane mesh to the layer.
    @add @mesh

  # Called per frame, update the objects in the layer however you want.
  # `elapsed` is the time in seconds since the last frame.
  update: (elapsed) ->

  # Called on every beat of the song.  Use it to change state to show it
  # reacting to the beat.
  onBeat: (beat) ->

    # In this case, set the plane to a random color.
    @baseColor.setRGB(
      Math.random(), Math.random(), Math.random()
    )

  # Called for each discernable note. Inspect the argment for details about the note.
  # onSegment: (segment) ->

  # Called at the start of every bar. Typically 4 beats in a 4/4 time signature.
  # onBar: (bar) ->

  # Called on each tatum. Tatums represent the lowest regular pulse train that a
  # listener intuitively infers from the timing of perceived musical events (segments).
  # onTatum: (tatum) ->

  # Called when the scene transitions and the layer should begin to die.  If you
  # override this, make sure to call `super`!
  # kill: ->

  # Called every frame after the layer has been killed. For as long as this method
  # returns `true` the layer will still be rendered. Make it return false when it's
  # death animation is completed.
  # alive: ->
