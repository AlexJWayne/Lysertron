window.Echotron ||= {}
Echotron.Echoes ||= {}

class Echotron.Echo extends THREE.Object3D
  components: {}
  uniformAttrs: {}

  constructor: (@scene) ->
    super

    @active = yes
    @initComponents()
    @initUniforms()

    @scene.add this

  # Is this silly? I'm thinkning it is.
  initComponents: ->
    @components =
      for own name, args of @components
        component = new Component[name](args || {})
        component.obj = this
        component

  # Setup list of uniforms sent to shaders.
  initUniforms: ->
    @uniforms = {}
    for name, type of @uniformAttrs
      @uniforms[name] =
        type:  type
        value: null

      # Define an accessor property on the prototype 
      unless name of this
        do (name, type) =>
          Object.defineProperty @constructor::, name,
            get: -> @uniforms[name].value
            set: (val) -> @uniforms[name].value = val

    return

  getShader: (name) ->
    Layers._shaders[name] || (
      $.ajax
        url: "js/layers/#{name}"
        async: no
        success: (data) => Layers._shaders[name] = data
      Layers._shaders[name]
    )

  
  getMatProperties: (name) ->
    {
      vertexShader:   @getShader "#{name}.vshader"
      fragmentShader: @getShader "#{name}.fshader"
      uniforms:       @uniforms
    }

  # Tells this layer to start to die. It will no longer receive song events,
  # and will be pruned when @alive() returns false.
  kill: ->
    @active = no

  # Called by LayerStack
  expired: ->
    not @active and not @alive()

  # Override. Should return false when the layer can be destoryed.
  alive: -> @active

  # Override. Do stuff on beats.
  beat: ->

  # Override. Do stuff on bars.
  bar: ->

  # Override. Do stuff on segment.
  segment: ->

  # Override. Do stuff on bars.
  tatum: ->

  # Override, calling super. Update state per frame.
  update: (elapsed) ->
    component.update(elapsed) for component in @components
