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
    document.body.appendChild container

    # renderer
    @renderer = new THREE.WebGLRenderer antialias: yes
    @renderer.setSize window.innerWidth, window.innerHeight
    @renderer.autoClear = no
    container.appendChild @renderer.domElement

    # # fps
    # @stats = new Stats
    # $(document.body).append @stats.domElement

    # resize
    THREEx.WindowResize @renderer, @camera

  # Initialize the song and bind song events.
  initSong: ->
    @song = new Lysertron.Song

    # Bind music events events
    @song.on 'musicEvent', (data) =>

      # Dispatch event to echoes
      @logicalLayers.background.stack.dispatchMusicEvent(data)
      @logicalLayers.midground .stack.dispatchMusicEvent(data)
      @logicalLayers.foreground.stack.dispatchMusicEvent(data)

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
    @songName = @getParam 'song'
  
  createSongSelector: ->
    $.get "/songs.json", (songs) =>
      select = $('<select>')
        .attr(id: 'song-select')
        .on 'change', ->
          window.location.search = "?song=#{ @value }"

      select.append $('<option>').text(' - Select Song - ')

      for song in songs
        option = $('<option>')
          .attr(value: song)
          .text(song)

        option.attr selected: yes if song is @getParam('song')

        select.append option

      $(document.body).append select

  # Start the song and the visualization.
  start: (playAudio = yes) ->
    @lastFrame = Date.now() / 1000
    @song.load @songName, =>
      @song.start playAudio
      @animate()
  
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

# Go
$ ->
  stage = window.stage = new Lysertron.Stage
  stage.start yes unless mocha?