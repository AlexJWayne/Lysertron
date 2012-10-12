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

layers = [
  new Layers.Planes scene
  new Layers.Cubes scene
]

# beat
beat = new Beat bpm: parseFloat(location.search?.replace '?bpm=', '')
beat.on 'beat', ->
  for layer in layers
    layer.beat()

lastFrame = Date.now() / 1000
update = ->
  now = Date.now() / 1000
  elapsed = now - lastFrame
  lastFrame = now

  for layer in layers
    layer.update elapsed

animate = ->
  requestAnimationFrame animate
  update()
  render()

render = ->
  renderer.render scene, camera

# GO
animate()