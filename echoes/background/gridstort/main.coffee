module.exports = class Gridstort extends Echotron.Echo
  uniformAttrs:
    time:      'f'
    amplitude: 'f'
    baseColor: 'c'
    density:   'f'
    opacity:   'f'
    speed:     'f'
    spinSpeed: 'f'
    drift:     'v2'
    intensity: 'f'


  constructor: ->
    super

    @time       = THREE.Math.randFloat 0, 10
    @amplitude  = 1
    @density    = THREE.Math.randFloat 20, 60
    @opacityMax = THREE.Math.randFloat 0.15, 0.3
    @opacity    = @opacityMax
    @speed      = THREE.Math.randFloat 5, 20
    @spinSpeed  = THREE.Math.randFloatSpread(45).rad
    @intensity  = THREE.Math.randFloat 10, 60
    @drift      = new THREE.Vector2(
      THREE.Math.randFloatSpread 0.1
      THREE.Math.randFloatSpread 0.1
    )

    @baseColor  = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      THREE.Math.randFloat 0.5, 1
      THREE.Math.randFloat 0.3, 0.7
    )

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(175, 175)
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
      )
    )
    @add @mesh


    @rotation.x = -180.rad

  beat: ->
    @opacity = @opacityMax

  bar: ->
    @amplitude = 1

  update: (elapsed) ->
    @time += elapsed

    @amplitude -= (elapsed * stage.song.bps) / 4
    @amplitude = 0 if @amplitude < 0
    
    @opacity -= @opacityMax * elapsed * stage.song.bps * 0.85
    @opacity = 0 if @opacity < 0

