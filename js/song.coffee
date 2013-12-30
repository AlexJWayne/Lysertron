# private
class Lysertron.Song

  # Class is an event emitter
  _.extend @::, Backbone.Events

  constructor: ->
    @lastScheduledIndices = {}
    for eventType in @eventTypes
      @lastScheduledIndices[eventType] = 0

  # Each kind of event the song can emit
  eventTypes: [
    'beat'
    'bar'
    'tatum'
    'segment'
    'section'
    'musicEvent'
  ]

  # Load a track and it's meta data
  load: (@name, cb) ->
    if @name
      @audio = $('<audio id="audio" preload="auto" controls>')

      # Load from a { blob, analysis } object assembled on the fly.
      if $.isPlainObject @name
        songObj = @name

        @audio.attr src: URL.createObjectURL(songObj.blob)
        $('body').append @audio
        @audio.on 'canplay', => cb this

        @data = songObj.analysis
        @cruncher = new Lysertron.MusicCruncher @data
        @cruncher.crunch()

        @bpm = @data.track.tempo
        @bps = @bpm / 60
        
      
      # Load from local files within the app by song name.
      else if @name isnt ''
        @audio.append $('<source>').attr(src: @musicFileUrl(@name).replace(/\.(\w+?$)/, '.ogg'))#, type: "audio/ogg")
        @audio.append $('<source>').attr(src: @musicFileUrl(@name))#, type: "audio/#{ @name.match(/\.(\w+?$)/)[1] }")
        $('body').append @audio
        @audio.on 'canplay', => cb this

        $.ajax
          url: @dataFileUrl(@name)
          dataType: 'json'
          async: no
          success: (@data) =>
            @cruncher = new Lysertron.MusicCruncher @data
            @cruncher.crunch()

            @bpm = @data.track.tempo
            @bps = @bpm / 60

    # No song specified, make up some events to trigger visuals.
    else
      @noSong = yes
      @loadDefaultSong()
      @cruncher = new Lysertron.MusicCruncher @data
      @cruncher.crunch()
      
      setTimeout (=> cb this), 0
      console.log "No song selected, using #{@bpm}bpm"

  generateSongEvents: (duration = 1) ->
    for i in [0...600] by duration
      start: i / @bps
      duration: duration / @bps
      confidence: 1
      volume: 0.9
      intensity: 1

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
      segments: @generateSongEvents 1/4


  # Schedule the song's event callbacks
  scheduleEvents: ->
    # Current time of the audio playback.
    playHead =
      if @audio
        @audio[0].currentTime
      else
        @startedAt ||= Date.now()
        (Date.now() - @startedAt) / 1000

    # Cycle through all event types.
    for eventType in ['musicEvent'] #@eventTypes
      
      # The array of events of this eventType.
      events = @data["#{eventType}s"]

      # Loop until we find a break condition.
      while true

        # Find the earliest unprocessed event.
        eventData = events[@lastScheduledIndices[eventType]]

        # Out of events! Abort while loop.
        break unless eventData

        # Event too far away! Abort while loop.
        break unless eventData.start < playHead + 1

        # Increment event index for next loop iteration.
        @lastScheduledIndices[eventType]++

        # Close over event type and data
        do (eventType, eventData) =>
          setTimeout =>
            # # Regularly log out how far behind we are.
            # if @audio && eventType is 'bar'
            #   console.log 'audio sync', @audio[0].currentTime - eventData.start

            # What it's all about, trigger the event of this type and pass in the event data.
            @trigger eventType, eventData

          # Schedule the event trigger in the future.
          , (eventData.start - playHead) * 1000

    return

  musicFileUrl: (path) ->
    if /^https?:/.test(path)
      path
    else
      "songs/#{ path }"

  dataFileUrl: (path) ->
    filename = path.replace(/\.\w+?$/, '.json')
    if /^https?:/.test(path)
      filename
    else
      "songs/#{ filename }"


  # Start the audio player
  start: (playAudio = yes) ->
    if @noSong
      @songEventsInterval = setInterval =>
        console.log 'asdasdasdasd'
        @scheduleEvents()
      , 250

    else
      @audio.on 'timeupdate', => @scheduleEvents()

      @audio[0].volume = if playAudio then 0.25 else 0
      @audio[0].play()

  stop: ->
    clearInterval @songEventsInterval if @songEventsInterval?
    @audio?[0].pause()
    @audio?.remove()