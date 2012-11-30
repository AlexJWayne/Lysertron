class Layers.Tunnel extends Layers.Base
  uniformAttrs:
    brightness:     'f'
    beatBrightness: 'f'
    ripples:        'fv1'
    ease:           'f'
    ringSize:       'f'
    baseColor:      'c'

  constructor: ->
    super

    @brightness     = 1
    @beatBrightness = 1
    @ripples        = [1]

    @baseColor  = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.5, 1)
    @spin = THREE.Math.randFloatSpread(180) * Math.PI/180
    @ease = THREE.Math.randFloat(2, 4)
    @ringSize = THREE.Math.randFloat(0.1, 0.6)

    @sides = 
      if Math.random() > 0.5
        40
      else
        [3, 4, 5, 6, 7][THREE.Math.randInt(0, 4)]


    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, 1000, 20000, @sides, 40
      new THREE.ShaderMaterial(
        _.extend(@getMatProperties('tunnel'),
          side:         THREE.BackSide
          transparent:  true
          blending:     THREE.AdditiveBlending
        )
      )
    )
    @mesh.material.side = THREE.BackSide

    @rotation.z = 90 * Math.PI/180

    @add @mesh

  beat: (beat) ->
    @beatBrightness = 1
    @ripples = @ripples[0..2]
    @ripples.unshift 1

  bar: (bar) ->
    @brightness = 1

  update: (elapsed) ->
    super
    @ripples =
      for ripple in @ripples
        ripple -= 0.4 * elapsed
        if ripple > 0
          ripple
        else
          0

    @beatBrightness -= 1.25 *elapsed
    @brightness -= 0.3 * elapsed
    @mesh.rotation.y += @spin * elapsed
