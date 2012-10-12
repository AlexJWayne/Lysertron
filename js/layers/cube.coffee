class Layers.Cube extends Layers.Base

  constructor: (@scene) ->
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
    @scene.add @mesh
    
    @shrinkTime = THREE.Math.randFloat 3, 5
    @rotSpeed   = THREE.Math.randFloatSpread 180 * (Math.PI/180)
    @mesh.position.set(
      THREE.Math.randFloatSpread 600
      THREE.Math.randFloatSpread 400
      THREE.Math.randFloatSpread 600
    )

  beat: ->
    @uniforms.beatScale.value = 1

  update: (elapsed) ->
    @uniforms.beatScale.value -= elapsed / @shrinkTime
    @mesh.rotation.y += @rotSpeed * elapsed

    @expired = yes if @uniforms.beatScale.value <= 0