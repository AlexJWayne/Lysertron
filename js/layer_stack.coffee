class Echotron.LayerStack
  constructor: (@layers = []) ->

  # Callback handlers for each song event which delegate to layer events.
  beat:     (data) -> layer.beat(data)     for layer in @layers when layer.active; return
  bar:      (data) -> layer.bar(data)      for layer in @layers when layer.active; return
  segment:  (data) -> layer.segment(data)  for layer in @layers when layer.active; return
  tatum:    (data) -> layer.tatum(data)    for layer in @layers when layer.active; return

  # Update all layers for a single frame.
  update: (elapsed) ->

    # Prune expired layers.
    livingLayers = []
    for layer in @layers
      if layer.expired()
        # Layer is dead, remove it.
        stage.scene.remove layer
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
    layer.kill() for layer in @layers
    for name, klass of window.Echotron.Echoes
      layer = new klass
      @push layer
      stage.scene.add layer
    return

  # Add an Echo to the stack. It must descend from Echotron.Echo.
  push: (layers...) ->
    for layer in layers
      unless layer instanceof Echotron.Echo
        throw new Error "LayerStack::push() object is not a Echotron.Echo"

      @layers.push layer

  # Convenience method to let you know if the stack has no layers.
  isEmpty: ->
    @layers.length is 0