module.exports = class Holo extends Echotron.EchoStack
  constructor: ->
    super

    @spin = new THREE.Vector3(
      THREE.Math.randFloatSpread(3.0).degToRad
      THREE.Math.randFloatSpread(3.0).degToRad
      THREE.Math.randFloatSpread(3.0).degToRad
    )

    @rotation.x = 45.degToRad

    for i in [0...12]
      @push new Chip(this, i/12, new THREE.Color().setHSV i/12, 0.75, 1)


  update: (elapsed) ->
    super
    @rotation.addSelf THREE.Vector3.temp(@spin).multiplyScalar(elapsed)


class Chip extends Echotron.Echo
  uniformAttrs:
    color: 'c'

  constructor: (@holo, angle, color) ->
    super

    @color = color
    
    qty = 60 # Chip fidelity

    @geom = new THREE.Geometry
    for i in [0...qty]
      @geom.vertices.push new THREE.Vector3(
        (i / qty * 360).degToRad # use as angle1
        (angle * 360).degToRad   # use as angle2
        0 # ignore
      )

    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    yes
        # depthTest:      no
        # blending:       THREE.AdditiveBlending
      )
    )

    @add @particles
