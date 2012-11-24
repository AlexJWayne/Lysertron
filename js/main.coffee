# init
scene = new THREE.Scene

# camera
camera = new THREE.PerspectiveCamera 70, window.innerWidth / window.innerHeight, 1, 100000
camera.position.set 600, 0, 0
camera.lookAt new THREE.Vector3
scene.add camera

# canvas
container = document.createElement 'div'
document.body.appendChild container

# renderer
renderer = new THREE.WebGLRenderer antialias: yes
renderer.setSize window.innerWidth, window.innerHeight
container.appendChild renderer.domElement

# layers
layers = []

# beat
song = scene.song = new Song
song.on 'beat', -> layer.beat() for layer in layers when layer.active; return
song.on 'bar',  -> layer.bar()  for layer in layers when layer.active; return

# New layers on new sections
song.on 'section', (section) ->
  console.log 'new section'

  layer.kill() for layer in layers
  layers.push new Layers.Planes scene
  layers.push new Layers.Cubes  scene

# Note how much drift we have
song.on 'bar', (bar) -> console.log 'drift', bar.start - song.audio[0].currentTime

lastFrame = Date.now() / 1000
update = ->

  now = Date.now() / 1000
  elapsed = now - lastFrame
  lastFrame = now

  # Prune dead layers
  tempLayers = []
  for layer in layers
    if layer.expired()
      scene.remove layer
    else
      tempLayers.push layer

  layers = tempLayers

  for layer in layers
    layer.update elapsed

animate = ->
  requestAnimationFrame animate
  update()
  render()

render = ->
  renderer.render scene, camera

# Get song from URL
songName = window.location.search.match(/^\?(\w+)$/)?[1] || 'Crawl'
console.log songName

# GO
song.load songName, ->
  song.start()
  animate()