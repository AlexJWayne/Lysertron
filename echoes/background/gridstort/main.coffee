module.exports = class Gridstort extends Echotron.Echo
  uniformAttrs:
    time:      'f'
    amplitude: 'f'
    baseColor: 'c'
    density:   'f'
    opacity:   'f'
    speed:     'f'

  constructor: ->
    super

    @time       = 0
    @amplitude  = 1
    @density    = THREE.Math.randFloat 20, 60
    @opacityMax = THREE.Math.randFloat 0.15, 0.3
    @opacity    = @opacityMax
    @speed      = THREE.Math.randFloat 6, 18
    @baseColor  = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      THREE.Math.randFloat 0.5, 1
      THREE.Math.randFloat 0, 0.5
    )

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(150, 150)
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        # transparent:    true
      )
    )
    @add @mesh


    @rotation.x = 180.rad

  beat: ->
    @opacity = @opacityMax

  bar: ->
    @amplitude = 1

  update: (elapsed) ->
    @time += elapsed

    @amplitude -= (elapsed * stage.song.bps) / 4
    @amplitude = 0 if @amplitude < 0
    
    @opacity -= @opacityMax * elapsed * stage.song.bps * 0.75
    @opacity = 0 if @opacity < 0

