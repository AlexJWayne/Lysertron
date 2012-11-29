class Layers.Tunnel extends Layers.Base
  constructor: (@scene) ->
    super

    @baseColor  = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.5, 1)
    
    @sides = 
      if Math.random() > 0.4
        40
      else
        [3, 4, 5, 6, 7][THREE.Math.randInt(0, 4)]

    @uniforms =
      brightness:
        type: 'f'
        value: 1

      colorR:
        type: 'f'
        value: @baseColor.r
      colorG:
        type: 'f'
        value: @baseColor.g
      colorB:
        type: 'f'
        value: @baseColor.b

    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, 1000, 20000, @sides, 40
      new THREE.ShaderMaterial(
        _.extend(@getMatProperties('tunnel'),
          uniforms: @uniforms
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
    @baseColor = @baseColor.clone()

  bar: (bar) ->
    @brightness = 1

  update: (elapsed) ->
    @brightness -= 0.4 * elapsed
    @setColor()

  Object.defineProperty @::, 'brightness'
    get: -> @uniforms.brightness.value
    set: (val) -> @uniforms.brightness.value = val

  setColor: ->
    color = @baseColor.clone().setRGB(
      @baseColor.r * @brightness
      @baseColor.g * @brightness
      @baseColor.b * @brightness
    )
    @mesh.material.color = color