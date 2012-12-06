class Echotron.Song

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
    if @name && @name isnt ''
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

    else
      @noSong = yes
      @loadDefaultSong()
      setTimeout (=> cb this), 0
      console.log "No song selected, using #{@bpm}bpm"

  generateSongEvents: (duration = 1) ->
    for i in [0...600] by duration
      start: i / @bps
      duration: duration / @bps
      confidence: 1

  loadDefaultSong: ->
    @bpm = 90
    @bps = @bpm / 60

    @data =
      meta: {}
      track:
        duration: 600
        tempo: 60
        time_signature: 4
        key: 0
        mode: 0

      sections: @generateSongEvents 16
      bars:     @generateSongEvents 4
      beats:    @generateSongEvents 1
      tatums:   @generateSongEvents 1/4
      segments: @generateSongEvents 1/16


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
  start: (playAudio = yes) ->
    if @noSong
      @scheduleEvents()

    else
      @audio.on 'playing', => @scheduleEvents()

      @audio[0].volume = if playAudio then 0.25 else 0
      @audio[0].play()