class Layers.Planes extends Layers.Base
  constructor: (@scene) ->

    # geom config
    @flipped = Math.random() > 0.75
    @height  = THREE.Math.randFloat 100, 500

    # Shader config
    @angle = 0

    @maxDrift = 300
    @drift =
      angle: Curve.low(Math.random()) * 60 * Math.PI / 180
      r: [Math.random() * 2 - 1, Math.random() * 2 - 1]
      g: [Math.random() * 2 - 1, Math.random() * 2 - 1]
      b: [Math.random() * 2 - 1, Math.random() * 2 - 1]

    @gridSize =
      r: THREE.Math.randFloat 75, 400
      g: THREE.Math.randFloat 75, 400
      b: THREE.Math.randFloat 75, 400


    # geometry
    @planes = [
      new Layers.Planes.Plane(@scene, this)
      new Layers.Planes.Plane(@scene, this)
    ]

    @planes[0].mesh.rotation.x = 90 * (Math.PI/180)
    @planes[0].mesh.position.y = @height

    @planes[1].mesh.rotation.x = 90 * (if @flipped then -1 else 1) * (Math.PI/180)
    @planes[1].mesh.position.y = -@height

  beat: ->
    plane.beat() for plane in @planes

  update: (elapsed) ->
    plane.update(elapsed) for plane in @planes
    
class Layers.Planes.Plane extends Layers.Base
  constructor: (@scene, @parent)->
    @uniforms =
      brightness:
        type: 'f'
        value: 1

      angle:
        type: 'f'
        value: 0

      shiftXr:
        type: 'f'
        value: 0

      shiftYr:
        type: 'f'
        value: 0

      shiftXg:
        type: 'f'
        value: 0

      shiftYg:
        type: 'f'
        value: 0

      shiftXb:
        type: 'f'
        value: 0

      shiftYb:
        type: 'f'
        value: 0

      gridSizeR:
        type: 'f'
        value: @parent.gridSize.r

      gridSizeG:
        type: 'f'
        value: @parent.gridSize.g

      gridSizeB:
        type: 'f'
        value: @parent.gridSize.b

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry 100000, 100000
      new THREE.ShaderMaterial(
        _.extend(@getMatProperties('plane'), uniforms: @uniforms)
      )
    )
    @mesh.doubleSided = true
    @scene.add @mesh

  beat: ->
    @uniforms.brightness.value = 1

  update: (elapsed) ->
    @uniforms.brightness.value -= 0.5 * elapsed
    @uniforms.brightness.value = 0 if @uniforms.brightness.value < 0

    @uniforms.angle.value   += @parent.drift.angle * elapsed * (@uniforms.brightness.value - 0.5)*2
    @uniforms.shiftXr.value += @parent.drift.r[0] * @parent.maxDrift * elapsed
    @uniforms.shiftXr.value += @parent.drift.r[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYr.value += @parent.drift.r[1] * @parent.maxDrift * elapsed
    @uniforms.shiftXg.value -= @parent.drift.g[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYg.value += @parent.drift.g[1] * @parent.maxDrift * elapsed
    @uniforms.shiftXb.value -= @parent.drift.b[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYb.value += @parent.drift.b[1] * @parent.maxDrift * elapsed

