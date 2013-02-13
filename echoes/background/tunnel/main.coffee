module.exports = class Tunnel extends Echotron.EchoStack
  constructor: ->
    super
    for i in [0..1]
      layer = new SingleTunnel
      layer.baseColor = new THREE.Color 0x000000 unless i == 0
      @push layer

class SingleTunnel extends Echotron.Echo
  uniformAttrs:
    inward:         'f'
    brightness:     'f'
    ripples:        'fv1'
    ease:           'f'
    ringSize:       'f'
    baseColor:      'c'
    ringColor:      'c'
    ringIntensity:  'f'
    fadeIn:         'f'

  initialize: ->
    @inward         = [1, 0].random()
    @brightness     = 1
    @ripples        = [1,0,0,0,0,0,0,0,0,0,0,0]
    @fadeIn         = 0

    @baseColor ||= new THREE.Color().setHSV Math.random(), 0.5, THREE.Math.randFloat(0.5, 1)
    @ringColor =   new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.6, 1.0), 1

    @spin          = THREE.Math.randFloatSpread(180).degToRad
    @ringSize      = THREE.Math.randFloat(0.2,  1.2)
    @ringIntensity = THREE.Math.randFloat(0.05, 0.4)
    @fadeSpeed     = THREE.Math.randFloat(0.2,  0.5)
    @fadeInTime    = 3 / stage.song.bps

    @ease = [
      THREE.Math.randFloat(0.75, 1.2)
      THREE.Math.randFloat(1.2, 6)
    ].random()

    @sides = [
      40
      [3, 4, 5, 6, 7].random()
    ].random()

    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, THREE.Math.randFloat(150, 250), 2000, @sides, 50
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    true
        blending:       THREE.AdditiveBlending
      )
    )
    @mesh.material.side = THREE.BackSide
    @mesh.material.depthWrite = no

    @rotation.x = 90.degToRad
    @position.z = -60

    @add @mesh

  alive: ->
    @brightness > 0 || _.max(@ripples) > 0

  onBeat: (beat) ->
    @ripples.unshift 1
    @ripples = @ripples[0..7]

  onBar: (bar) ->
    @brightness = 1

  update: (elapsed) ->
    if @fadeIn < 1
      @fadeIn += elapsed / @fadeInTime
    else
      @fadeIn = 1 

    @ripples =
      for ripple in @ripples
        ripple -= @fadeSpeed * elapsed
        if ripple > 0
          ripple
        else
          0

    @brightness -= 0.25 * elapsed
    @mesh.rotation.y += @spin * elapsed