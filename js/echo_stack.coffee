class Echotron.EchoStack extends Echotron.Echo
  constructor: ->
    @stack = new Echotron.LayerStack this
    super

  push: (echoes...) ->
    for echo in echoes
      @add echo
      @stack.push echo
    return

  onBeat:     (beat)    -> @stack.onBeat    beat
  onBar:      (bar)     -> @stack.onBar     bar
  onSegment:  (segment) -> @stack.onSegment segment
  onTatum:    (tatum)   -> @stack.onTatum   tatum

  update: (elapsed) ->
    @stack.update elapsed

  kill: ->
    super
    for layer in @stack.layers
      layer.kill()
    return

  alive: ->
    !@stack.isEmpty()
