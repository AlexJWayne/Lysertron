module.exports = class Lattice extends Echotron.EchoStack
  constructor: ->
    super

    @push (new Strut(i/12) for i in [0..11])...

class Strut extends Echotron.Echo
  constructor: (@angle) ->
    super

    @angle *= 360.rad

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(3, 800, 1, 100)
      new THREE.ShaderMaterial(
        side: THREE.BackSide
        wireframe: no
        vertexShader: assets['vert.glsl']
      )
    )

    @mesh.rotation.x = 90.rad
    @rotation.z = @angle

    # @mesh.position.z = 350
    @mesh.position.y = -30

    @add @mesh