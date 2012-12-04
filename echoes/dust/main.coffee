module.exports = class Dust extends Echotron.Echo
  uniformAttrs:
    baseColor:     'c'
    size:          'f'
    particleAlpha: 'f'
    crispness:     'f'

  constructor: ->
    super

    @direction = 1
    @speed = THREE.Math.randFloat(1, 3)
    @damp  = THREE.Math.randFloat(1.5, 4)
    @vel   = @speed * 3

    @size = THREE.Math.randFloat(2, 6)
    @position.z = Math.random()
    @scale.setLength 0

    @particleAlpha = 0.1
    @crispness = 0.9

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 1)
      1
    )

    @spin = new THREE.Vector3(
      THREE.Math.randFloatSpread(90) * Math.PI/180
      THREE.Math.randFloatSpread(90) * Math.PI/180
      THREE.Math.randFloatSpread(90) * Math.PI/180
    )

    @geom = new THREE.Geometry
    for i in [0..THREE.Math.randFloat(150, 750)]
      @geom.vertices.push new THREE.Vector3(
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
      ).setLength THREE.Math.randFloat(4, 70)

    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["dust.vshader"]
        fragmentShader: assets["dust.fshader"]
        transparent:    yes
        depthWrite:     false

        blending:       THREE.CustomBlending
        blendSrc:       THREE.SrcAlphaFactor
        blendDst:       THREE.OneMinusSrcAlphaFactor
      )
    )

    @add @particles

  beat: ->
    @vel = @speed * @direction
    @direction *= -1

  update: (elapsed) ->
    super
    
    @vel -= @vel * @damp * elapsed
    @scale.addSelf new THREE.Vector3(1,1,1).multiplyScalar(@vel * elapsed)

    @rotation.addSelf @spin.clone().multiplyScalar(elapsed)

  kill: ->
    super
    @vel = @speed
    @damp = 0

  alive: ->
    @scale.length() < 10