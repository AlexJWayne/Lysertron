module.exports = class Holo extends Echotron.Echo
  constructor: ->
    super

    @count =
      u: 60 # Chip fidelity
      v: 12 # Chip count

    @geom = new THREE.Geometry
    for u in [0...@count.u]
      for v in [0...@count.v]
        @geom.vertices.push new THREE.Vector3(
          (u / @count.u * 360).rad # use as angle1
          (v / @count.v * 360).rad # use as angle2
          0                   # ignore
        )

    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        # uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    yes
        # depthWrite:     no
        blending:       THREE.AdditiveBlending
      )
    )

    @add @particles

    @spin = new THREE.Vector3(
      THREE.Math.randFloatSpread(30).rad
      THREE.Math.randFloatSpread(30).rad
      THREE.Math.randFloatSpread(30).rad
    )

    @rotation.x = 90.rad

  update: (elapsed) ->
    @rotation.addSelf THREE.Vector3.temp(@spin).multiplyScalar(elapsed)