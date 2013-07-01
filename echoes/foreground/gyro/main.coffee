module.exports = class Gyro extends Lysertron.LayerStack
  initialize: ->
    @animTime = THREE.Math.randInt(1, 2)

    @thickness = [
      THREE.Math.randFloat(0.75, 2)
      THREE.Math.randFloat(0.75, 2)
    ]
    @thicknessCurve = [Curve.easeInSine, Curve.easeOutSine].random()
    @stretch = [
      [
        THREE.Math.randFloat(0.3, 0.6)
        THREE.Math.randFloat(1.5,   3)
      ].random()
      [
        THREE.Math.randFloat(0.3, 0.6)
        THREE.Math.randFloat(1.5,   3)
      ].random()
    ]

    @pulse = [
      THREE.Math.randFloat( 1.0,  2.5)
      THREE.Math.randFloat(-0.5, -1.0)
    ].random()

    @color = new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0.5, 1)
    )

    @lightRingWidths = []
    @lightRingSpeeds = []
    for i in [1..3]
      @lightRingWidths.push THREE.Math.randFloat(0.03, 0.15)
      @lightRingSpeeds.push THREE.Math.randFloat(0.25, 0.75) * [1, -1].random()

    @fanAngle = THREE.Math.randFloat(10, 45).degToRad

    @radialDistance = THREE.Math.randFloat 3, 10
    
    @lightenOnNudge = [1, -0.5].random()
    @direction = 1 #[1, -1].random()
    @currentRing = if @direction is 1 then 0 else 3

    @stack.push(
      new Ring this, 10 + @radialDistance * 0, 0
      new Ring this, 10 + @radialDistance * 1, 1
      new Ring this, 10 + @radialDistance * 2, 2
      new Ring this, 10 + @radialDistance * 3, 3
    )

    @tumble = new THREE.Vector3(
      THREE.Math.randFloatSpread(90).degToRad
      THREE.Math.randFloatSpread(90).degToRad
      THREE.Math.randFloatSpread(90).degToRad
    )


  onBeat: (beat) ->
    layer = @stack.layers[@currentRing]
    @add layer
    layer.nudge beat.duration

    @currentRing += @direction
    @currentRing = 0 if @currentRing >= @stack.layers.length
    @currentRing = @stack.layers.length-1 if @currentRing < 0

  update: (elapsed) ->
    super
    @rotation.add THREE.Vector3.temp(@tumble).multiplyScalar(elapsed)


    
class Ring extends Lysertron.Layer
  uniformAttrs:
    progress: 'f'
    elapsed: 'f'
    lightenOnNudge: 'f'
    color: 'c'
    lightRingBrightness: 'f'
    lightRingSpeeds: 'fv1'
    lightRingWidths: 'fv1'

  constructor: (@gyro, @radius, @ringIndex) ->
    super

    @visible = yes

    {
      @animTime
      @pulse
      @color
      @lightenOnNudge
      @lightRingSpeeds
      @lightRingWidths
    } = @gyro

    @rotation.x = 90.degToRad
    @rotation.z = @gyro.fanAngle * @ringIndex

    thicknessMix = @gyro.thicknessCurve(@ringIndex / 3)
    thickness = @gyro.thickness[0] * (1 - thicknessMix) + @gyro.thickness[1] * thicknessMix

    @add @mesh = new THREE.Mesh(
      new THREE.TorusGeometry @radius, thickness, 16, 60
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        fragmentShader: assets['frag.glsl']
        vertexShader:   assets['vert.glsl']
        transparent: yes
      )
    )

  nudge: (duration) ->
    @rotationflipped = !@rotationflipped
    @lightRingBrightness = 1

    @progress = 0
    new TWEEN.Tween(this)
      .to({progress: 1}, (duration * @animTime).ms)
      .easing(TWEEN.Easing.Back.Out)
      .start()


  kill: ->
    super
    new TWEEN.Tween(@scale)
      .to({x:0, y:0, z:0}, (1.5/stage.song.bps + @ringIndex/4).ms)
      .easing(TWEEN.Easing.Back.In)
      .onComplete(=> @visible = no)
      .start()

  update: (elapsed) ->
    @elapsed = Date.now() / 1000 % 10000
    @lightRingBrightness -= elapsed * 0.25
    @lightRingBrightness = 0 if @lightRingBrightness < 0
    @mesh.rotation.x = (if @rotationflipped then 180 else 0).degToRad + @progress * 180.degToRad

  alive: ->
    @visible