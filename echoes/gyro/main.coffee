module.exports = class Gyro extends Echotron.EchoStack
  uniformAttrs:
    baseColor: 'c'

  constructor: ->
    super    

    @animTime = THREE.Math.randFloat(1.5, 2.5) / stage.song.bps
    @thickness = [
      THREE.Math.randFloat(0.75, 2)
      THREE.Math.randFloat(0.75, 2)
    ]
    @thicknessCurve = [Curve.easeInSine, Curve.easeOutSine].random()
    @stretch = [
      1
      THREE.Math.randFloat(0.3, 0.6)
      THREE.Math.randFloat(2,   3)
    ].random()

    @direction = [1, -1].random()
    @currentRing = if @direction is 1 then 0 else 3

    @stack.push(
      new Ring this, 15, 0
      new Ring this, 20, 1
      new Ring this, 25, 2
      new Ring this, 30, 3
    )

    @tumble = new THREE.Vector3(
      THREE.Math.randFloatSpread(90) * Math.PI/180
      THREE.Math.randFloatSpread(90) * Math.PI/180
      THREE.Math.randFloatSpread(90) * Math.PI/180
    )


  beat: () ->
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
  constructor: (@gyro, @radius, @ringIndex) ->
    super

    @animTime = @gyro.animTime

    @rotation.z = THREE.Math.randFloat(0, 360) * Math.PI/180

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
    
    @mesh.scale.z = @gyro.stretch

  nudge: ->
    @lastNudgeAt = new Date().getTime()/1000

  update: (elapsed) ->
    sinceNudge = new Date().getTime()/1000 - @lastNudgeAt
    if sinceNudge < @animTime
      @mesh.rotation.x = Tween.easeOutSine sinceNudge, 0, 180 * Math.PI/180, @animTime
    else
      @mesh.rotation.x = 0
