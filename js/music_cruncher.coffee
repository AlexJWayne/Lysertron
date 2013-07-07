class Lysertron.MusicCruncher
  constructor: (@data) ->

  # Crunch the data!
  crunch: ->
    start = performance.now()

    @computeVolumes()
    @computeIntesities()
    @aggregateMusicEvents()

    console.log 'Song Data Crunched:', Math.round(performance.now() - start), 'ms'

  # Combine all music events into a single stream, grouping together events that happens at the same time.
  aggregateMusicEvents: ->
    @events = []
    eventsByTime = {}

    # Aggregate these event types.
    for eventType in ['section', 'bar', 'beat', 'tatum', 'segment']

      # For each event of this type.
      for eventData in @data["#{eventType}s"]

        # Save when it starts, this will be the key used to group events together.
        start = eventData.start

        # Start a new aggregate object one doesn't yet exist.
        unless eventsByTime[start]
          obj = { start }
          eventsByTime[start] = obj
          @events.push obj

        # Add this event to aggegrate event object for this moment.
        eventsByTime[start][eventType] = eventData

    # Sort events by their start date, in case they got jumbled.
    @events = @events.sort (a, b) ->
      a.start - b.start

    # Export back onto the data object we were given.
    @data.musicEvents = @events

  # Figure out min and max loudness and add a normalized "volume" to each segment.
  computeVolumes: ->
    @minLoudness = -60
    @maxLoudness = -60

    # Get max/min loudness of the entire song.
    for segment in @data.segments
      @maxLoudness = segment.loudness_max if segment.loudness_max > @maxLoudness
      @minLoudness = segment.loudness_max if segment.loudness_max < @minLoudness

    # Add normalized volume to every segment.
    for segment in @data.segments
      segment.volume = @loudnessToVolume segment.loudness_max

    # Add normalized volumes to rhythmic events based on the segment volume within them.
    for eventType in ['sections', 'bars', 'beats']
      for event in @data[eventType]
        unless event.volume?
          event.volume = 0
          for segment in @eventsInRange 'segments', event
            event.volume = segment.volume if segment.volume > event.volume

    return

  # Add an intensity to every rhythmic event representing how many notes get played.
  #   0.0: no notes, quiet.
  #   1.0: same number of notes as tatums, steady.
  #   2.0: twice the number of segments as tatums, intense.
  #   3.0: triple the number of segments as tatums, hold onto your butts.
  computeIntesities: ->
    for eventType in ['sections', 'bars', 'beats']
      for event in @data[eventType]
        segments = @eventsInRange 'segments', event
        tatums   = @eventsInRange 'tatums', event
        event.intensity = segments.length / tatums.length

    return

  # Convert a loudness value into a normalized volume
  loudnessToVolume: (loudness) ->
    (loudness - @minLoudness) / (@maxLoudness - @minLoudness)

  # Get all events of a certain in a range of time.
  eventsInRange: (type, { start, duration }) ->
    for event in @data[type] when start < event.start < start + duration
      event
