class Echotron.Stage
  constructor: ->
    @initEngine()
    @initSong()

  # Initialize the THREE.js scene, camera and renderer.
  initEngine: ->
    @scene = new THREE.Scene
    @scene.fog = new THREE.Fog(0x111111, 0, 5000)
    # @scene.add @scene.fog

    # camera
    @camera = new THREE.PerspectiveCamera 70, window.innerWidth / window.innerHeight, 1, 5000
    @camera.position.set 0, 0, -60
    @camera.lookAt new THREE.Vector3(0, 0, 0)
    @scene.add @camera

    # canvas
    container = document.createElement 'div'
    document.body.appendChild container

    # renderer
    @renderer = new THREE.WebGLRenderer antialias: yes
    @renderer.setSize window.innerWidth, window.innerHeight
    container.appendChild @renderer.domElement

    # fps
    @fpsContainer = $('<div id="fps">')
    $(document.body).append @fpsContainer

    # Layers array
    @layerStack = new Echotron.LayerStack

  # Initialize the song and bind song events.
  initSong: ->
    @song = @scene.song = new Echotron.Song

    # Bind all events
    for eventType in ['bar', 'beat', 'tatum', 'segment']
      do (eventType) =>
        @song.on eventType, (eventData) =>
          @layerStack[eventType](eventData)
    
    # Transition layers on new sections
    @song.on 'section', (section) =>
      console.log 'section', section.start
      @layerStack.transition()

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
    @fps = 1/elapsed

    # Update all layers
    @layerStack.update elapsed

  # This is the main run loop.
  animate: =>
    requestAnimationFrame @animate
    @update()
    @render()

  # Render the scene.
  render: =>
    @renderer.render @scene, @camera
    @fpsContainer.text Math.round(@fps)

# Go
$ ->
  stage = window.stage = new Echotron.Stage
  stage.start no