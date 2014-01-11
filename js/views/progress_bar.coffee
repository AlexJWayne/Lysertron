Lysertron.Views ||= {}

class Lysertron.Views.ProgressBar

  constructor: ->
    @container = $('<div id="progressBar">')
    @bar       = $('<div id="progressBarValue">').appendTo @container
    @container.prependTo $(document.body)
    this

  text: (newText) ->
    @bar.text newText
    this

  completion: (newCompletion) ->
    fullWidth = @container.width() - 20
    @bar.css width: "#{ newCompletion * fullWidth }px"
    this

  class: (newClass) ->
    @bar.addClass newClass
    this

  destroy: ->
    @container.remove()
    this