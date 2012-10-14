class Layers.Cubes extends Layers.Base
  constructor: (@scene) ->
    super
    @cubes = []

  beat: ->
    cube = new Layers.Cubes.Cube(this)
    @add cube
    @cubes.push cube
  
  update: (elapsed) ->
    cube.update elapsed for cube in @cubes
    
    tempCubes = []
    for cube in @cubes
      if cube.expired
        @remove cube
      else
        tempCubes.push cube

    @cubes = tempCubes


class Layers.Cubes.Cube extends Layers.Base

  constructor: ->
    super
    material = {}

    @uniforms =
      beatScale:
        type: 'f'
        value: 1

    size = THREE.Math.randFloat 100, 200
    @mesh = new THREE.Mesh(
      new THREE.CubeGeometry size, size, size, 1, 1, 1
      new THREE.ShaderMaterial(
        _.extend @getMatProperties('cube'), uniforms: @uniforms
      )
    )

    @add @mesh
    
    @shrinkTime = THREE.Math.randFloat 2, 6
    @rotSpeed   = THREE.Math.randFloatSpread 180 * (Math.PI/180)
    @mesh.position.set(
      THREE.Math.randFloatSpread 400
      THREE.Math.randFloatSpread 400
      THREE.Math.randFloatSpread 400
    )

  beat: ->
    @uniforms.beatScale.value = 1

  update: (elapsed) ->
    @uniforms.beatScale.value -= elapsed / @shrinkTime
    @mesh.rotation.y += @rotSpeed * elapsed

    @expired = yes if @uniforms.beatScale.value <= 0