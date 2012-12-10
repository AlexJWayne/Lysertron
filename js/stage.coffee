class Echotron.Stage
  constructor: ->
    @initEngine()
    @initSong()

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
        
    @logicalLayers.background.stack = new Echotron.LayerStack @logicalLayers.background.scene, [], 'background'
    @logicalLayers.midground.stack  = new Echotron.LayerStack @logicalLayers.midground.scene,  [], 'midground'
    @logicalLayers.foreground.stack = new Echotron.LayerStack @logicalLayers.foreground.scene, [], 'foreground'

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

    # fps
    @stats = new Stats
    $(document.body).append @stats.domElement

    # resize
    THREEx.WindowResize @renderer, @camera

  # Initialize the song and bind song events.
  initSong: ->
    @song = new Echotron.Song

    # Bind all events
    for eventType in ['bar', 'beat', 'tatum', 'segment']
      do (eventType) =>
        @song.on eventType, (eventData) =>
          @logicalLayers.background.stack[eventType](eventData)
          @logicalLayers.midground.stack[eventType](eventData)
          @logicalLayers.foreground.stack[eventType](eventData)
    
    # Transition layers on new sections
    @song.on 'section', (section) =>
      @logicalLayers.background.stack.transition()
      @logicalLayers.midground.stack.transition()
      @logicalLayers.foreground.stack.transition()

    # Get song from URL
    @songName = getParam 'song'
  
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

    # Update all layers
    for echoType, logicalLayer of @logicalLayers
      logicalLayer.stack.update elapsed

  # This is the main run loop.
  animate: =>
    requestAnimationFrame @animate
    @update()
    @render()

    @stats.end()
    @stats.begin()    

  # Render the scene.
  render: =>
    @renderer.clear()
    @renderer.render @logicalLayers.background.scene, @camera
    @renderer.render @logicalLayers.midground.scene,  @camera
    @renderer.render @logicalLayers.foreground.scene, @camera

# Go
$ ->
  stage = window.stage = new Echotron.Stage
  stage.start yes unless mocha?