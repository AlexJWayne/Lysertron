class Layers.Cubes extends Layers.Base
  components:
    Rotator:
      maxRoll:  90
      maxPitch: 90

  constructor: (@scene) ->
    super
    @cubes = []
    @size = [
      THREE.Math.randFloat(25, 200)
      THREE.Math.randFloat(25, 200)
    ]
    @spawnQty = THREE.Math.randInt(2, 6)
    @shrinkTime = THREE.Math.randInt(3, 6) / @scene.song.bps

    @color =
      r: THREE.Math.randFloat(0, 1)
      g: THREE.Math.randFloat(0, 1)
      b: THREE.Math.randFloat(0, 1)

  beat: ->
    for i in [1..@spawnQty]
      cube = new Layers.Cubes.Cube(this)
      @add cube
      @cubes.push cube
    return
  
  update: (elapsed) ->
    super
    cube.update elapsed for cube in @cubes
    
    tempCubes = []
    for cube in @cubes
      if cube.expired
        @remove cube
      else
        tempCubes.push cube

    @cubes = tempCubes

  alive: ->
    @cubes.length > 0


class Layers.Cubes.Cube extends Layers.Base
  # components:
  #   Rotator:
  #     maxRoll:  30
  #     maxPitch: 30

  constructor: (parent)->
    super
    material = {}

    @expired = no

    @uniforms =
      beatScale:
        type: 'f'
        value: 1

      colorR:
        type: 'f'
        value: parent.color.r

      colorG:
        type: 'f'
        value: parent.color.g

      colorB:
        type: 'f'
        value: parent.color.b

    size = THREE.Math.randFloat parent.size...
    @mesh = new THREE.Mesh(
      new THREE.CubeGeometry size, size, size, 1, 1, 1
      new THREE.ShaderMaterial(
        _.extend @getMatProperties('cube'), uniforms: @uniforms
      )
    )

    @add @mesh
    
    @mesh.position.set(
      THREE.Math.randFloatSpread 500
      THREE.Math.randFloatSpread 500
      THREE.Math.randFloatSpread 500
    )

  beat: ->
    @uniforms.beatScale.value = 1

  update: (elapsed) ->
    super
    @uniforms.beatScale.value -= elapsed / @parent.shrinkTime

    @expired = yes if @uniforms.beatScale.value <= 0