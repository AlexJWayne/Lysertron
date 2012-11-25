class window.Stage
  constructor: ->
    @initEngine()
    @initSong()

  # Initialize the THREE.js scene, camera and renderer.
  initEngine: ->
    @scene = new THREE.Scene

    # camera
    @camera = new THREE.PerspectiveCamera 70, window.innerWidth / window.innerHeight, 1, 100000
    @camera.position.set 600, 0, 0
    @camera.lookAt new THREE.Vector3
    @scene.add @camera

    # canvas
    container = document.createElement 'div'
    document.body.appendChild container

    # renderer
    @renderer = new THREE.WebGLRenderer antialias: yes
    @renderer.setSize window.innerWidth, window.innerHeight
    container.appendChild @renderer.domElement

    # Layers array
    @layers = []

  # Initialize the song and bind song events.
  initSong: ->
    @song = @scene.song = new Song

    # Bind all events
    for eventType in ['bar', 'beat', 'tatum', 'segment']
      do (eventType) =>
        @song.on eventType, (eventData) =>
          for layer in @layers when layer.active
            layer[eventType](eventData)
          return
    
    # New layers on new sections
    @song.on 'section', (section) =>
      console.log 'section', section.start

      layer.kill() for layer in @layers
      @layers.push new Layers.Planes @scene
      @layers.push new Layers.Cubes  @scene

    # Get song from URL
    @songName = window.location.search.match(/^\?(\w+)$/)?[1] || 'Crawl'
  
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

    # Prune expired layers.
    livingLayers = []
    for layer in @layers
      if layer.expired()
        @scene.remove layer
      else
        livingLayers.push layer

    @layers = livingLayers

    # Update non expired layers.
    for layer in @layers
      layer.update elapsed

  # This is the main run loop.
  animate: =>
    requestAnimationFrame @animate
    @update()
    @render()

  # Render the scene.
  render: =>
    @renderer.render @scene, @camera

# Go
stage = window.stage = new Stage
stage.start(no)