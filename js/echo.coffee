window.Echotron ||= {}
Echotron.Echoes ||= {}
Echotron.Echoes.foreground ||= []
Echotron.Echoes.midground  ||= []
Echotron.Echoes.background ||= []

class Echotron.Echo extends THREE.Object3D
  uniformAttrs: {}

  # Override, calling super. Setup your Echo however you need.
  constructor: ->
    super
    @active = yes
    @initUniforms()

    # Call a non-constructor init function.
    @initialize?()

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
  
  # Tells this layer to start to die. It will no longer receive song events,
  # and will be pruned when @alive() returns false.
  _kill: ->
    @active = no
    @kill()

  # Call private @_kill() unless we have already been killed.
  kill: ->
    @_kill() if @active


  # Called by LayerStack
  expired: ->
    not @active and not @alive()

  # Override. Should return false when the layer can be destoryed.
  alive: -> @active

  # Override. Do stuff on beats.
  onBeat: ->

  # Override. Do stuff on bars.
  onBar: ->

  # Override. Do stuff on segment.
  onSegment: ->

  # Override. Do stuff on bars.
  onTatum: ->

  # Override. Update state per frame.
  update: (elapsed) ->
