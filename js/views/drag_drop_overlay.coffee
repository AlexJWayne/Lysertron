Lysertron.Views ||= {}

class Lysertron.Views.DragDropOverlay

  constructor: ->
    body = $(document.body)

    @container = $('<div id="dragDropOverlay">')
      .text('Drop to upload and play music file')
      .css(lineHeight: "#{ body.height() }px")
      .hide()
      .appendTo(body)
    
    this

  text: (newText) ->
    @container.text newText
    this

  hide: -> @container.hide()
  show: -> @container.show()

  destroy: ->
    @container.remove()
    this