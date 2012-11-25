class window.Song

  # Class is an event emitter
  _.extend @::, Backbone.Events

  constructor: ->

  # Each kind of event the song can emit
  eventTypes: [
    'beat'
    'bar'
    'tatum'
    'segment'
    'section'
  ]

  # Load a track and it's meta data
  load: (@name, cb) ->
    @audio = $('<audio id="audio" preload="auto" controls>')
    @audio.attr src: "songs/#{@name}.m4a"
    $('body').append @audio

    @audio.on 'canplay', => cb this

    $.ajax
      url: "songs/#{@name}.json"
      dataType: 'json'
      async: no
      success: (@data) =>
        @bpm = @data.track.tempo
        @bps = @bpm / 60

  # Schedule the song's event callbacks
  scheduleEvents: ->
    for eventType in @eventTypes
      for eventData in @data["#{eventType}s"]
        do (eventType, eventData) =>
          setTimeout =>
            @trigger eventType, eventData
          , eventData.start * 1000

    return

  # Start the audio player
  start: (cb) ->
    # @scheduleEvents()
    @audio.on 'playing', =>
      @scheduleEvents()
      cb? this

    @audio[0].play()