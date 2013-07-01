# Echo -> Layer

window.Lysertron ||= {}
Lysertron.Echoes ||= {}
Lysertron.Echoes.foreground ||= []
Lysertron.Echoes.midground  ||= []
Lysertron.Echoes.background ||= []

class Lysertron.Echo extends THREE.Object3D
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


  # Called by LayerGroup, returns true if the layer should be removed.
  expired: ->
    not @active and not @alive()

  # Called by the music playing, triggering event callbacks.
  dispatchMusicEvent: (data) ->
    @onMusicEvent data

    @onBeat data.beat if data.beat
    @onBar data.bar if data.bar
    @onSegment data.segment if data.segment
    @onTatum data.tatum if data.tatum


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

  # Override. Do stuff on any music event.
  # There is a key for each type of event that is ocurring.
  onMusicEvent: ->

  # Override. Update state per frame.
  update: (elapsed) ->
