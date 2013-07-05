module.exports = class Dust extends Lysertron.LayerStack
  initialize: ->
    @push new SingleDust()
    @push new SingleDust direction: -1

class SingleDust extends Lysertron.Layer
  uniformAttrs:
    baseColor:     'c'
    size:          'f'
    particleAlpha: 'f'

  initialize: (options = {}) ->
    @direction = options.direction || 1
    
    @size = THREE.Math.randFloat(3, 8)
    @position.z = Math.random()
    @scale.setLength 0

    @particleAlpha = THREE.Math.randFloat(0.3, 0.7)

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 0.25)
      1
    )

    @spin = new THREE.Vector3(
      THREE.Math.randFloatSpread(30).degToRad
      THREE.Math.randFloatSpread(30).degToRad
      THREE.Math.randFloatSpread(30).degToRad
    )

    @geom = new THREE.Geometry
    qty = THREE.Math.randInt(150, 600)
    console.log qty
    for i in [0..qty]
      @geom.vertices.push new THREE.Vector3(
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
      ).setLength THREE.Math.randFloat(4, 70)

    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    yes
        depthWrite:     no
      )
    )

    @add @particles

    @onBeat duration: 1

  onBeat: (beat) ->
    targetScale = if @direction > 0 then 1.5 else 0.75

    new TWEEN.Tween(@scale)
      .to({x:targetScale, y:targetScale, z:targetScale}, beat.duration * 1000)
      .easing(TWEEN.Easing.Sinusoidal.InOut)
      .start()

    @direction *= -1

  update: (elapsed) ->
    super
    @rotation.add THREE.Vector3.temp(@spin).multiplyScalar(elapsed)

  kill: ->
    targetScale = 50
    new TWEEN.Tween(@scale)
      .to({x:targetScale, y:targetScale, z:targetScale}, 3 * 1000)
      .easing(TWEEN.Easing.Sinusoidal.InOut)
      .start()

  alive: ->
    @scale.length() < 49