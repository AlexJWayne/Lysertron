# private
class Lysertron.Stage
  constructor: ->
    @initEngine()
    @initSong()
    @createSongSelector()

  # Initialize the THREE.js scene, camera and renderer.
  initEngine: ->

    # Setup a scene and a stack for each logical layer
    @logicalLayers =
      background:
        scene: new THREE.Scene
      
      midground:
        scene: new THREE.Scene

      foreground:
        scene: new THREE.Scene
        
    @logicalLayers.background.stack = new Lysertron.LayerGroup @logicalLayers.background.scene, [], 'background'
    @logicalLayers.midground.stack  = new Lysertron.LayerGroup @logicalLayers.midground.scene,  [], 'midground'
    @logicalLayers.foreground.stack = new Lysertron.LayerGroup @logicalLayers.foreground.scene, [], 'foreground'

    # camera
    @camera = new THREE.PerspectiveCamera 70, window.innerWidth / window.innerHeight, 1, 5000
    @camera.position.set 0, 0, -60
    @camera.lookAt new THREE.Vector3(0, 0, 0)

    @logicalLayers.background.scene.add @camera
    @logicalLayers.midground.scene.add @camera
    @logicalLayers.foreground.scene.add @camera

    # canvas
    container = document.createElement 'div'
    document.body.insertBefore container, document.body.firstChild

    # renderer
    @renderer = new THREE.WebGLRenderer antialias: yes
    @renderer.setSize window.innerWidth, window.innerHeight
    @renderer.autoClear = no
    container.appendChild @renderer.domElement

    if @getParam('vr')
      @oculusRenderer = new THREE.OculusRiftEffect @renderer
      @oculusRenderer.blankScene = new THREE.Scene()
      @oculusRenderer.setInterpupillaryDistance 2

      $(window).on 'keydown', (e) =>
        switch e.keyCode
          when 70 # f
            if vr.isFullScreen()
              vr.exitFullScreen()
            else
              vr.enterFullScreen()

          when 69 # e
            if confirm("Swap left and right?")
              @oculusRenderer.setInterpupillaryDistance -@oculusRenderer.getInterpupillaryDistance()


    # # fps
    # @stats = new Stats
    # $(document.body).append @stats.domElement

    # resize
    unless @oculusRenderer
      THREEx.WindowResize @renderer, @camera

  # Initialize the song and bind song events.
  initSong: (@songName) ->
    @song.stop() if @playing

    @song = new Lysertron.Song

    # Bind music events events
    @song.on 'musicEvent', (data) =>

      # Dispatch event to echoes
      @logicalLayers.background.stack.dispatchMusicEvent(data)
      @logicalLayers.midground.stack.dispatchMusicEvent(data)
      @logicalLayers.foreground.stack.dispatchMusicEvent(data)

      # Activate Arduino
      if Lysertron.Arduino.exists
        Lysertron.Arduino.dispatchMusicEvent(data)

      # Transition layers on new sections
      if data.section
        fullTransition()

      # Force a transition on the 8th bar if one hasnt' happened yet.
      if data.bar
        barCount++
        fullTransition() if barCount > 8

    
    # trigger scene transitions
    barCount = 0
    fullTransition = =>
      barCount = 0
      @logicalLayers.background.stack.transition()
      @logicalLayers.midground.stack.transition()
      @logicalLayers.foreground.stack.transition()

    # Get song from URL
    @songName ||= @getParam 'song'
  
  createSongSelector: (selectedSongObj)->
    @songSelector?.remove()

    # Load song library from local storage.
    Lysertron.Library.load (lib) =>
      @songSelector = $('<select>')
        .attr(id: 'song-select')
        .on 'change', =>
          stage.initSong lib.get(md5: @songSelector.val())
          stage.start()

        @songSelector.append $('<option>').text(' - Select Song - ')

        for songObj in lib.songObjs
          option = $('<option>')
            .attr(value: songObj.md5)
            .text("#{ songObj.artist } - #{ songObj.title }")

          if selectedSongObj?.md5 is songObj.md5
            option.attr(selected: yes)

          @songSelector.append option

        $(document.body).append @songSelector

  # Start the song and the visualization.
  start: (playAudio = yes) ->
    @playing = true
    @lastFrame = Date.now() / 1000
    @song.load @songName, =>
      @song.start playAudio
      @animate()
      @showTimeline() if @getParam 'timeline'
  
  # Update all layers on each frame.
  update: =>

    # Calculate elpased time.
    now = Date.now() / 1000
    elapsed = now - @lastFrame
    @lastFrame = now

    TWEEN.update()

    # Update all layers
    for echoType, logicalLayer of @logicalLayers
      logicalLayer.stack.update elapsed

    return

  # This is the main run loop.
  animate: =>
    requestAnimationFrame @animate
    @update()
    @render()

    # @stats.end()
    # @stats.begin()    

  # Render the scene.
  render: =>

    if @oculusRenderer
      # Render a blank scene and clear the buffer
      @oculusRenderer.render @oculusRenderer.blankScene, @camera, undefined, true

      # With a cleared canvas, render each layer
      @oculusRenderer.render @logicalLayers.background.scene, @camera, undefined, false
      @oculusRenderer.render @logicalLayers.midground.scene,  @camera, undefined, false
      @oculusRenderer.render @logicalLayers.foreground.scene, @camera, undefined, false

    else
      @renderer.clear yes, yes, yes
      @renderer.render @logicalLayers.background.scene, @camera

      @renderer.clear no, yes, yes
      @renderer.render @logicalLayers.midground.scene,  @camera

      @renderer.clear no, yes, yes
      @renderer.render @logicalLayers.foreground.scene, @camera

  # Return the value of a query string parameter.
  getParam: (name) ->
    name = name
      .replace(/[\[]/, "\\\[")
      .replace(/[\]]/, "\\\]")

    regexS = "[\\?&]" + name + "=([^&#]*)"
    regex = new RegExp regexS
    results = regex.exec window.location.search
    if results
      decodeURIComponent results[1].replace(/\+/g, " ")
    else
      null

  # Convert event name into a standardized handler name.
  #   beat -> onBeat
  getHandlerName: (eventName) ->
    "on#{ eventName.charAt(0).toUpperCase() }#{ eventName[1...eventName.length] }"

  showTimeline: ->
    data = @song.data
    duration = data.track.duration

    timeline = $('<div>').attr(id: 'timeline').appendTo $(document.body)
    current = $('<div>').attr(id: 'timeline-current').appendTo $(document.body)

    row = (events) ->
      rowEl = $('<div>').addClass('row').appendTo timeline
      for event in events
        rowEl.append $('<div>')
                      .addClass('block')
                      .css
                        left: "#{event.start / duration * 100}%"
                        'background-color': "rgba(0,0,0, #{event.volume ? 1})"

    row data.sections
    row data.bars
    row data.beats
    row data.segments

    update = ->
      progress = stage.song.audio.get(0).currentTime / duration
      timeline.css
        '-webkit-transform': "translate3D(#{(-progress) * 100}%, 0, 0)",
        '-moz-transform': "translate3D(#{(-progress) * 100}%, 0, 0)"

      requestAnimationFrame(update)

    update()



# Go
$ ->
  stage = window.stage = new Lysertron.Stage
  # stage.start yes unless mocha?