class Layers.Planes extends Layers.Base
  components: {
    Rotator:
      maxRoll: 45
      maxPitch: 15
  }

  constructor: (@scene) ->
    super

    # geom config
    @height  = THREE.Math.randFloat 250, 500

    # Shader config
    @angle = 0

    @maxDrift = 300
    @decayCoef = THREE.Math.randFloat(0.5, 1.0)
    @drift =
      angle: Curve.low(Math.random()) * 60 * Math.PI / 180
      r: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)]
      g: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)]
      b: [THREE.Math.randFloatSpread(1), THREE.Math.randFloatSpread(1)]

    @gridSize =
      r: THREE.Math.randFloat 75, 600
      g: THREE.Math.randFloat 75, 600
      b: THREE.Math.randFloat 75, 600

    # geometry
    @planes = [
      new Layers.Planes.Plane(this, side: THREE.FrontSide)
      new Layers.Planes.Plane(this, side: THREE.BackSide)
    ]

    @add plane for plane in @planes

    @planes[0].mesh.rotation.x = 90 * (Math.PI/180)
    @planes[0].mesh.position.y = @height

    @planes[1].mesh.rotation.x = 90 * (Math.PI/180)
    @planes[1].mesh.position.y = -@height

  bar: ->
    plane.beat() for plane in @planes

  update: (elapsed) ->
    super    
    plane.update(elapsed) for plane in @planes

  alive: ->
    @planes.brightness > 0

    
class Layers.Planes.Plane extends Layers.Base
  constructor: (@owner, { @side })->
    super

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
        value: @owner.gridSize.r

      gridSizeG:
        type: 'f'
        value: @owner.gridSize.g

      gridSizeB:
        type: 'f'
        value: @owner.gridSize.b

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry 100000, 100000
      new THREE.ShaderMaterial(
        _.extend(@getMatProperties('plane'),
          uniforms: @uniforms
          side:     @side
          transparent: true
        )
      )
    )
    @mesh.doubleSided = true
    @mesh.transparent = true
    @add @mesh

  beat: ->
    @uniforms.brightness.value = 1

  update: (elapsed) ->
    decay = @parent.scene.song.bps * @owner.decayCoef / @parent.scene.song.data.track.time_signature

    @uniforms.brightness.value -= decay * elapsed
    @uniforms.brightness.value = 0 if @uniforms.brightness.value < 0

    @uniforms.angle.value   += @parent.drift.angle * elapsed * (@uniforms.brightness.value - 0.5)*2
    @uniforms.shiftXr.value += @parent.drift.r[0] * @parent.maxDrift * elapsed
    @uniforms.shiftXr.value += @parent.drift.r[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYr.value += @parent.drift.r[1] * @parent.maxDrift * elapsed
    @uniforms.shiftXg.value -= @parent.drift.g[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYg.value += @parent.drift.g[1] * @parent.maxDrift * elapsed
    @uniforms.shiftXb.value -= @parent.drift.b[0] * @parent.maxDrift * elapsed
    @uniforms.shiftYb.value += @parent.drift.b[1] * @parent.maxDrift * elapsed

