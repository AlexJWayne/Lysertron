module.exports = class Gyro extends Echotron.EchoStack
  initialize: ->
    @animTime = THREE.Math.randFloat(2, 4) / stage.song.bps
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

    @motionCurve = [
      TWEEN.Easing.Elastic.Out
      TWEEN.Easing.Back.Out
      TWEEN.Easing.Exponential.Out
    ].random()

    # Elastic curve is steeper, it needs more time to keep from being jarring.
    @animTime *= 1.5 if @motionCurve is TWEEN.Easing.Elastic.Out

    @fanAngle = THREE.Math.randFloat(10, 45).degToRad

    @radialDistance = THREE.Math.randFloat 3, 10
    
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


  onBeat: ->
    layer = @stack.layers[@currentRing]
    @add layer
    layer.nudge()

    @currentRing += @direction
    @currentRing = 0 if @currentRing >= @stack.layers.length
    @currentRing = @stack.layers.length-1 if @currentRing < 0

  update: (elapsed) ->
    super
    @rotation.addSelf THREE.Vector3.temp(@tumble).multiplyScalar(elapsed)


    
class Ring extends Echotron.Echo
  uniformAttrs:
    progress: 'f'
    pulse: 'f'
    color: 'c'

  constructor: (@gyro, @radius, @ringIndex) ->
    super

    @visible = yes

    {
      @animTime
      @pulse
      @color
      @motionCurve
    } = @gyro

    @rotation.z = @gyro.fanAngle * @ringIndex #THREE.Math.randFloat(0, 360).degToRad

    thicknessMix = @gyro.thicknessCurve(@ringIndex / 3)
    thickness = @gyro.thickness[0] * (1 - thicknessMix) + @gyro.thickness[1] * thicknessMix

    @add @mesh = new THREE.Mesh(
      new THREE.TorusGeometry @radius, thickness, 10, 60
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        fragmentShader: assets['frag.glsl']
        vertexShader:   assets['vert.glsl']
      )
    )
    
    # @mesh.scale.z = @gyro.stretch[0] * (1 - thicknessMix) + @gyro.stretch[1] * thicknessMix

  nudge: ->
    @progress = 0
    new TWEEN.Tween(this)
      .to({progress: 1}, @animTime.ms)
      .easing(@motionCurve)
      .start()


  kill: ->
    super
    new TWEEN.Tween(@scale)
      .to({x:0, y:0, z:0}, (1.5/stage.song.bps + @ringIndex/4).ms)
      .easing(TWEEN.Easing.Back.In)
      .onComplete(=> @visible = no)
      .start()

  update: (elapsed) ->
    @mesh.rotation.x = @progress * 180.degToRad

  alive: ->
    @visible