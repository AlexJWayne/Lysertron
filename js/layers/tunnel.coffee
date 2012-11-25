class Layers.Tunnel extends Layers.Base
  constructor: (@scene) ->
    super

    @brightness = 1
    @baseColor    = new THREE.Color 0x000000
    @currentColor = new THREE.Color 0x00ff00

    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, 1000, 20000, 20, 40
      new THREE.MeshBasicMaterial color: @currentColor
    )
    @mesh.material.side = THREE.BackSide


    @rotation.z = 90 * Math.PI/180

    @add @mesh

  beat: (beat) ->
    @currentColor = @baseColor.clone()
    @setColor()

  bar: (bar) ->
    @brightness = 1

  segment: (segment) ->
    r = _(segment.pitches[0..3]).reduce((sum = 0, num) -> sum + num) / 2
    g = _(segment.pitches[4..7]).reduce((sum = 0, num) -> sum + num) / 2
    b = _(segment.pitches[8..11]).reduce((sum = 0, num) -> sum + num) / 2

    @baseColor.setRGB r, g, b

  update: (elapsed) ->
    @brightness -= 0.6 * elapsed
    @setColor()

  setColor: ->
    color = @currentColor.clone().setRGB(
      @currentColor.r * @brightness
      @currentColor.g * @brightness
      @currentColor.b * @brightness
    )
    @mesh.material.color = color