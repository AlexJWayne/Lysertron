module.exports = class Holo extends Lysertron.Layer

  uniformAttrs:
    size: 'f'
    specular: 'f'
    light: 'v3'

  initialize: ->
    @initParams()

    # Vertex attributes used in the vertex shader
    @vertexAttrs =
      whitening:
        type: 'f'
        value: []

      vertexColor:
        type: 'c'
        value: []

    # Create a geometry object and populate it with vertices.
    # No need to position them yet, we do that every frame.
    @geometry = new THREE.Geometry
    if @show.nodes
      for u in [0...@qty.segments]
        for v in [0...@qty.chips]

          # Create vertex and save it's u and v with it.
          vert = new THREE.Vector3
          vert.u = u / @qty.segments
          vert.v = v / @qty.chips

          # Add the vertex to the geometry and set a color for it.
          @geometry.vertices.push vert
          @vertexAttrs.whitening.value.push 0
          @vertexAttrs.vertexColor.value.push(
            new THREE.Color()
              .setHSV(vert.v, 1, 1)
              .lerp(@baseColor, @baseColorBlend)
          )

    # Create the particle system with our geometry and a simple material
    @particles = new THREE.ParticleSystem(
      @geometry
      new THREE.ShaderMaterial(
        vertexColors:   THREE.VertexColors  # use the vertex colors set above
        uniforms:       @uniforms
        attributes:     @vertexAttrs
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    yes
        depthTest:      no
      )
    )

    # Spawn with a random rotation
    @particles.rotation.set(
      THREE.Math.randFloat 0, 360.degToRad
      THREE.Math.randFloat 0, 360.degToRad
      THREE.Math.randFloat 0, 360.degToRad
    )

    # Tween up the birth animation
    @animateBirth()

    # A rotating, involuting torus covered in particles definately needs to be
    # depth sorted to draw properly.
    @particles.sortParticles = yes

    # add the particle system to the scene
    @add @particles


    # # Create the chip highlight lines.
    # chipLinesGeometry = new THREE.Geometry()
    # for v in [0...@qty.chips]
    #   lastVert = null
    #   for u in [0...128]
    #     vert = new THREE.Vector3()
    #     vert.u = u / 127
    #     vert.v = v / @qty.chips

    #     chipLinesGeometry.vertices.push lastVert, vert if lastVert
    #     lastVert = vert

    # @chipLines = new THREE.Line(
    #   chipLinesGeometry
    #   new THREE.LineBasicMaterial(
    #     color: @baseColor
    #     linewidth: @lineWidth
    #   )
    #   THREE.LinePieces
    # )

    # if @show.lines
    #   @particles.add @chipLines

  initParams: ->
    borderWidth = THREE.Math.randFloat 0.05, 0.4

    @light = new THREE.Vector3(
      THREE.Math.randFloatSpread 1
      THREE.Math.randFloatSpread 1
      THREE.Math.randFloatSpread 1
    ).normalize()

    @specular = THREE.Math.randFloat 0.0, 0.75

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0.25, 1)
    )
    @baseColorBlend = [THREE.Math.randFloat(0, 1), 1].random()

    # rotation speeds on all 3 axes
    @rotationSpeedX = THREE.Math.randFloatSpread 60.degToRad
    @rotationSpeedY = THREE.Math.randFloatSpread 60.degToRad
    @rotationSpeedZ = THREE.Math.randFloatSpread 60.degToRad

    # speed of torus involution
    @involutionSpeed = THREE.Math.randFloat(0.05, 0.2) * [1, -1].random()
    @involution = 0

    # Size of each particle
    @sizeOnBeat = THREE.Math.randFloat 25, 85
    @size = @sizeOnBeat

    # radius to the center of the ring
    @r1 = 15 + TWEEN.Easing.Quadratic.In(Math.random()) * 25

    # radius of the ring
    @r2 = THREE.Math.randFloat @r1/4, @r1

    # number of particles
    @qty =

      # number of torus chips
      chips: THREE.Math.randInt 3, 24

      # fidelity of each chip
      segments: THREE.Math.randInt 32, 80

    # Line width
    @lineWidth = THREE.Math.randFloat 2, 5


    # What to render
    switch THREE.Math.randInt(0,1)
      when 0
        @show =
          nodes: yes
          lines: no
      when 1
        @show =
          nodes: yes
          lines: yes
    

  animateBirth: ->
    r1 = @r1
    r2 = @r2
    @r1 = @r2 = 0

    curves = [
      TWEEN.Easing.Sinusoidal
      TWEEN.Easing.Cubic
      TWEEN.Easing.Quadratic
      TWEEN.Easing.Back
    ]

    new TWEEN.Tween(this)
      .to({r1}, (1.5 / stage.song.bps).ms)
      .easing(curves.random().Out)
      .start()

    new TWEEN.Tween(this)
      .to({r2}, (1 / stage.song.bps).ms)
      .easing(curves.random().Out)
      .start()

  update: (elapsed) ->
    # update the particle size
    @particles.material.size = @size
    # @chipLines.material.linewidth = @size * 0.15

    # add rotation speeds to to the torus rotation
    @particles.rotation.x += @rotationSpeedX * elapsed
    @particles.rotation.y += @rotationSpeedY * elapsed
    @particles.rotation.z += @rotationSpeedZ * elapsed

    # add involution speed to curent involution amount
    @involution += @involutionSpeed * elapsed

    # loop through each vertex and update the position according to current torus config
    for vert in @geometry.vertices
      @placeVert vert

    # for vert in @chipLines.geometry.vertices
    #   @placeVert vert

    for i in [0...@vertexAttrs.whitening.value.length]
      amount = @vertexAttrs.whitening.value[i]
      amount -= elapsed * 3
      amount = 0 if amount < 0
      @vertexAttrs.whitening.value[i] = amount

    # bust vertex cache so the new vertex data is loaded
    @geometry.verticesNeedUpdate  = yes
    # @chipLines.geometry.verticesNeedUpdate = yes
  
  # Toroidalize!
  placeVert: (vert) ->
    # convert from 0 to 1 to 0 to 2*PI
    u = vert.u * 2 * Math.PI
    v = vert.v * 2 * Math.PI

    # update v to make a holochip, instead of a simple ring
    v += u

    # update u with current involution amount
    u += @involution * 2 * Math.PI

    # convert u, v to torus coordinates according to the standard torus formula
    vert.set(
      (@r1 + @r2 * Math.cos(u)) * Math.cos(v)
      (@r1 + @r2 * Math.cos(u)) * Math.sin(v)
      @r2 * Math.sin(u) * 1.6180339887 # PHI
    )


  onBeat: (beat) ->
    @shrink = !@shrink
    targetSize = if @shrink then @sizeOnBeat/2 else @sizeOnBeat

    new TWEEN.Tween(this)
      .to({size: targetSize}, beat.duration.ms)
      .easing(TWEEN.Easing.Sinusoidal[if @shrink then 'In' else 'Out'])
      .start()

  onSegment: (segment) ->
    pitches = segment.pitches
    return unless pitches

    for vertIndex in [0...@geometry.vertices.length]
      vertex = @geometry.vertices[vertIndex]
      whitenings = @vertexAttrs.whitening.value

      for i in [0...pitches.length]
        if i == Math.floor(vertex.v * 12) && pitches[i] > whitenings[vertIndex]
          whitenings[vertIndex] = pitches[i]

  kill: ->
    new TWEEN.Tween(this)
      .to({size: 0}, 0.6.ms)
      .easing(TWEEN.Easing.Sinusoidal.In)
      .start()

  alive: ->
    @size > 0.1