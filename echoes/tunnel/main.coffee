class @Main extends Echotron.Echo
  uniformAttrs:
    brightness:     'f'
    ripples:        'fv1'
    ease:           'f'
    ringSize:       'f'
    baseColor:      'c'

  constructor: ->
    super

    @brightness     = 1
    @ripples        = [1, 0, 0, 0]

    @baseColor  = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.5, 1)
    @spin = THREE.Math.randFloatSpread(180) * Math.PI/180
    @ease = THREE.Math.randFloat(2, 4)
    @ringSize = THREE.Math.randFloat(0.1, 0.3)

    @sides =
      if Math.random() > 0.5
        40
      else
        [3, 4, 5, 6, 7].random()


    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, THREE.Math.randFloat(100, 200), 2000, @sides, 50
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["tunnel.vshader"]
        fragmentShader: assets["tunnel.fshader"]
        side:           THREE.BackSide
        transparent:    true
        blending:       THREE.AdditiveBlending
      )
    )
    @mesh.material.side = THREE.BackSide

    @rotation.x = 90 * Math.PI/180

    @add @mesh

  beat: (beat) ->
    @ripples.unshift 1
    @ripples = @ripples[0..3]

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

    @brightness -= 0.3 * elapsed
    @mesh.rotation.y += @spin * elapsed
