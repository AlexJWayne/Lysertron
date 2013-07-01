# Create a stack of layers that can react to beat events.
# Useful when your custom layer actually manages a number
# of layers.
class Lysertron.LayerStack extends Lysertron.Layer
  constructor: ->
    @stack = new Lysertron.LayerGroup this
    super

  push: (echoes...) ->
    for echo in echoes
      @add echo
      @stack.push echo
    return

  dispatchMusicEvent: (data) ->
    # Dispatch event to layers in the stack.
    @stack.dispatchMusicEvent data

    # Fire event handles on the echo stack.
    @onMusicEvent data
    @onBeat data.beat if data.beat
    @onBar data.bar if data.bar
    @onSegment data.segment if data.segment
    @onTatum data.tatum if data.tatum

  # noop handles for the echostack
  onMusicEvent: (musicEvent) ->
  onBeat:       (beat)       ->
  onBar:        (bar)        ->
  onSegment:    (segment)    ->
  onTatum:      (tatum)      ->

  update: (elapsed) ->
    @stack.update elapsed

  _kill: ->
    super
    for layer in @stack.layers
      layer._kill()
    return

  alive: ->
    !@stack.isEmpty()
