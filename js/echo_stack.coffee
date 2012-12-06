class Echotron.EchoStack extends Echotron.Echo
  constructor: ->
    super
    @stack = new Echotron.LayerStack

  push: (echoes...) ->
    for echo in echoes
      @add echo
      @stack.push echo
    return

  beat:     (beat)    -> @stack.beat    beat
  bar:      (bar)     -> @stack.bar     bar
  segment:  (segment) -> @stack.segment segment
  tatum:    (tatum)   -> @stack.tatum   tatum

  update: (elapsed) ->
    @stack.update elapsed

  kill: ->
    super
    for layer in @stack.layers
      layer.kill()
    return

  alive: ->
    !@stack.isEmpty()
