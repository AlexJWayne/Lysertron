module.exports = class Warpdrive extends Echotron.Echo
  uniformAttrs:
    time: 'f'

  constructor: ->
    super

    @time = 0

    @geom = new THREE.Geometry()
    for i in [0...1000]
      vert1 = new THREE.Vector3(
        THREE.Math.randFloatSpread(200)
        THREE.Math.randFloatSpread(200)
        THREE.Math.randFloatSpread(200)
      )

      vert2 = new THREE.Vector3(
        vert1.x
        vert1.y
        vert1.z + 30
      )

      @geom.vertices.push vert1, vert2

    @mesh = new THREE.Line(
      @geom
      new THREE.LineBasicMaterial color: 0xffff00, linewidth: 2, vertexShader: assets['vert.glsl']
      THREE.LinePieces
    )

    @add @mesh

  update: (elapsed) ->
    @time += elapsed