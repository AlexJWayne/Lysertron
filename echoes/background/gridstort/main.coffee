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
    birth:     'f'
    death:     'f'


  constructor: ->
    super

    @time         = THREE.Math.randFloat 0, 10
    @amplitude    = 0
    @amplitudeDir = 1
    @density      = THREE.Math.randFloat 10, 30
    @opacityMax   = THREE.Math.randFloat 0.05, 0.2
    @opacity      = @opacityMax
    @speed        = THREE.Math.randFloat 5, 20
    @spinSpeed    = THREE.Math.randFloatSpread(45).degToRad
    @intensity    = THREE.Math.randFloat 15, 75
    @birth        = 0
    @death        = 0

    @drift        = new THREE.Vector2(
      THREE.Math.randFloatSpread 0.3
      THREE.Math.randFloatSpread 0.3
    )


    @baseColor  = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      THREE.Math.randFloat 0.5, 1
      THREE.Math.randFloat 0.3, 0.7
    )

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(1750, 1750)
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        depthTest:      no
      )
    )
    @add @mesh


    @rotation.x = THREE.Math.randFloat(-130, -210).degToRad

  onBeat: ->
    @opacity = @opacityMax

  onBar: ->
    @amplitudeDir = 1

  update: (elapsed) ->
    @birth += elapsed
    @time += elapsed

    unless @active
      @death += elapsed

    if @amplitudeDir is 1
      @amplitude += elapsed * stage.song.bps * 4
      if @amplitude > 1
        @amplitude = 1
        @amplitudeDir = -1

    else
      @amplitude -= (elapsed * stage.song.bps) / 4
      @amplitude = 0 if @amplitude < 0
    
    @opacity -= @opacityMax * elapsed * stage.song.bps * 0.65
    @opacity = 0.02 if @opacity < 0.02

    @rotation.z += elapsed / 4.0

  alive: ->
    @death < 1