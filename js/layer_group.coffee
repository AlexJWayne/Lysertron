class Lysertron.LayerGroup
  constructor: (@scene, @layers = [], @echoType) ->

  echoTypes: [
    'background'
    'midground'
    'foreground'
  ]

  # Delegate song events which delegate to layers.
  dispatchMusicEvent: (data) ->
    for layer in @layers when layer.active
      layer.dispatchMusicEvent data
    return


  # Update all layers for a single frame.
  update: (elapsed) ->

    # Prune expired layers.
    livingLayers = []
    for layer in @layers
      if layer.expired()
        # Layer is dead, remove it.
        @scene.remove layer
      else
        # Layer is still alive, keep it.
        livingLayers.push layer

    @layers = livingLayers

    # Update non expired layers.
    for layer in @layers
      layer.update elapsed

  # Add a stack of new Echo layers, creating a new scene.
  # Kill old layers so they can decay.
  transition: ->
    return unless @echoType
    layer._kill() for layer in @layers


    # Force a specific echo via page query string.
    forcedEchoName = stage.getParam(@echoType) || stage.getParam(@echoType.replace /ground$/, '')
    if forcedEchoName
      klass = (echoClass for echoClass in Lysertron.Layers[@echoType] when echoClass._id is forcedEchoName)[0]
      if klass
        console.log "Forced #{@echoType}:", forcedEchoName
      else
        console.error "Forced #{@echoType} not found:", forcedEchoName

    # Nothing forced, pick a random one.
    else
      klass = Lysertron.Layers[@echoType].random()

    if klass
      layer = new klass
      @push layer
      @scene?.add layer

  # Add an Echo to the stack. It must descend from Lysertron.Layer.
  push: (layers...) ->
    for layer in layers
      unless layer instanceof Lysertron.Layer
        throw new Error "LayerGroup::push() object is not a Lysertron.Layer"

      @layers.push layer

  # Convenience method to let you know if the stack has no layers.
  isEmpty: ->
    @layers.length is 0