module.exports = class PistonChute extends Lysertron.Layer
  uniformAttrs:
    baseColor: 'c'

  initialize: ->
    @radialQty = 24
    @lengthQty = 24

    @radius  = 120
    @length = 5000

    @currentBeatCount = 0

    @rotationSpeed = new THREE.Vector3(
      0
      THREE.Math.randFloatSpread(40.degToRad)
      0
    )

    @baseColor = new THREE.Color().setHSV(
      Math.random()
      0.5
      0.5
    )
    

    @chute = new THREE.Mesh(
      new THREE.CylinderGeometry(@radius, @radius, @length, 64, 1, true)
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        vertexShader:   assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
        side: THREE.DoubleSide
      )
    )
    @chute.rotation.x = 90.degToRad
    @add @chute

    # Pistons
    @pistonGeom = new THREE.CubeGeometry(20, 20, 20)
    @pistonMat  = new THREE.ShaderMaterial(
      uniforms: @uniforms
      vertexShader:   assets['vert.glsl']
      fragmentShader: assets['frag.glsl']
    )

    @pistons = []
    for u in [0...@radialQty]
      for v in [0..@lengthQty]
        piston = new THREE.Mesh(
          @pistonGeom
          @pistonMat
        )
        piston.direction = -1
        piston.scale.z = @getScale piston

        piston.direction = [1, -1].random()
        piston.beatNum = [0..3].random()

        angle = u / @radialQty * 2 * Math.PI
        angle += v * 2

        piston.position.set(
          Math.sin(angle) * @radius
          v * 30
          Math.cos(angle) * @radius
        )

        piston.rotation.y = angle
        piston.rotation.z = 45.degToRad

        @pistons.push piston
        @chute.add piston

  getScale: (piston) ->
    if piston.direction is 1
      3.2
    else
      0.5


  update: (elapsed) ->
    rotation = THREE.Vector3.temp(@rotationSpeed)
    rotation.multiplyScalar elapsed
    @chute.rotation.add rotation

  onBeat: (beat) ->
    @currentBeatCount++

    animateUpBeat = @currentBeatCount % 4
    for piston in @pistons when piston.beatNum is animateUpBeat
      # easing = [TWEEN.Easing.Cubic, TWEEN.Easing.Quadratic, ]
      piston.direction = 1
      new TWEEN.Tween(piston.scale)
        .to({z: @getScale(piston)}, beat.duration * 1000)
        .easing(TWEEN.Easing.Back.In)
        .start()

    animateDownBeat = (@currentBeatCount - 1) % 4
    for piston in @pistons when piston.beatNum is animateDownBeat
      piston.direction = -1
      new TWEEN.Tween(piston.scale)
        .to({z: @getScale(piston)}, beat.duration * 3 * 1000)
        .easing(TWEEN.Easing.Cubic.InOut)
        .start()