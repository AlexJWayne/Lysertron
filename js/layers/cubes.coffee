class Layers.Cubes extends Layers.Base
  components:
    Rotator:
      maxRoll:  90
      maxPitch: 90

  constructor: (@scene) ->
    super
    @cubes = new LayerStack
    @size = [
      THREE.Math.randFloat(50, 200)
      THREE.Math.randFloat(50, 200)
    ]
    @spawnQty   = THREE.Math.randInt(2, 6)
    @shrinkTime = THREE.Math.randInt(3, 6) / @scene.song.bps

    direction = [1, -1][THREE.Math.randInt(0, 1)]
    @speed      = THREE.Math.randFloat(0, 500) * -direction
    @accel      = THREE.Math.randFloat(0, 1000) *  direction

    @color =
      r: THREE.Math.randFloat(0, 1)
      g: THREE.Math.randFloat(0, 1)
      b: THREE.Math.randFloat(0, 1)

  beat: ->
    for i in [1..@spawnQty]
      cube = new Layers.Cubes.Cube this, color: @color, speed: @speed, accel: @accel, size: @size
      @add cube
      @cubes.push cube
    return

  bar: ->
    for i in [1..@spawnQty*4]
      cube = new Layers.Cubes.Cube this, color: @color, speed: Math.abs(@speed*2), accel: @accel, size: @size.map((s)-> s/3)
      @add cube
      @cubes.push cube
  
  update: (elapsed) ->
    super
    @cubes.update elapsed
    
  alive: -> !@cubes.isEmpty()


class Layers.Cubes.Cube extends Layers.Base
  # components:
  #   Rotator:
  #     maxRoll:  30
  #     maxPitch: 30

  constructor: (@parent, { @color, @speed, @accel, @size })->
    super
    material = {}

    @uniforms =
      beatScale:
        type: 'f'
        value: 1

      colorR:
        type: 'f'
        value: @color.r

      colorG:
        type: 'f'
        value: @color.g

      colorB:
        type: 'f'
        value: @color.b

    size = THREE.Math.randFloat @size...
    @mesh = new THREE.Mesh(
      new THREE.CubeGeometry size, size, size, 1, 1, 1
      new THREE.ShaderMaterial(
        _.extend @getMatProperties('cube'), uniforms: @uniforms
      )
    )

    @add @mesh
    
    @mesh.position.set(
      THREE.Math.randFloatSpread 300
      THREE.Math.randFloatSpread 300
      THREE.Math.randFloatSpread 300
    )

    @accel = @accel
    @vel = @mesh.position.clone().setLength @speed

  alive: ->
    @uniforms.beatScale.value > 0

  update: (elapsed) ->
    super
    @uniforms.beatScale.value -= elapsed / @parent.shrinkTime

    @vel.addSelf @mesh.position.clone().setLength(@accel * elapsed)
    @mesh.position.addSelf @vel.clone().multiplyScalar(elapsed)

    @kill() if @uniforms.beatScale.value <= 0














