module.exports = class Lattice extends Echotron.EchoStack
  initialize: ->
    @flipped = [yes, no].random()
    @doubled = [yes, no].random()

    @spinSpeed = THREE.Math.randFloatSpread(60).degToRad

    @offsetTime = 10
    
    @bulge = new THREE.Vector3

    @animateTweens()

    @position.z = 750

    @spiral1 = new Spiral this, @flipped
    @push @spiral1

    if @doubled
      @spiral2 = new Spiral this, !@flipped, @spiral1
      @push @spiral2

  animateTweens: ->
    qty = THREE.Math.randInt(4, 12)
    @offsetValues = 
      x: (THREE.Math.randFloatSpread(5).degToRad for i in [0...qty])
      y: (THREE.Math.randFloatSpread(5).degToRad for i in [0...qty])

    @offsetValues.x.push @offsetValues.x[@offsetValues.x.length - 1]
    @offsetValues.y.push @offsetValues.y[@offsetValues.y.length - 1]

    @bulgevalues = {
      x: (THREE.Math.randFloatSpread(75) for i in [0...4])
      y: (THREE.Math.randFloatSpread(75) for i in [0...4])
    }

    new TWEEN.Tween(@rotation)
      .to(@offsetValues, @offsetTime.ms)
      .interpolation(TWEEN.Interpolation.CatmullRom)
      .onComplete(=> @animateTweens() if @active)
      .start()

    new TWEEN.Tween(@bulge)
      .to(@bulgevalues, @offsetTime.ms)
      .interpolation(TWEEN.Interpolation.CatmullRom)
      .start()

  update: (elapsed) ->
    super
    @rotation.z += elapsed * @spinSpeed



class Spiral extends Echotron.EchoStack
  constructor: (@lattice, @flipped, source = {}) ->
    super

    @bulge = @lattice.bulge

    @color = source.color || new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0.5, 1)
      THREE.Math.randFloat(0.6, 1)
    )
    @qty   = source.qty   || THREE.Math.randInt 3, 15
    @width = source.width || THREE.Math.randFloat(80, 300) / @qty
    @twist = source.twist || THREE.Math.randFloat 2, 12
    @skew  = source.skew  || [1, 3].random()

    @flippedDir = if @flipped then -1 else 1

    @rotDirection   = source.rotDirection   || [1, -1].random()
    @rotSpeed       = source.rotSpeedTarget || THREE.Math.randFloat(30, 90).degToRad

    @push (new Strut(this, i/@qty, @flipped) for i in [0...@qty])...

    @position.z = -400 + @rotDirection * 25

  setSkew: (@skew) ->
    for layer in @stack.layers
      layer.skew = @skew

  update: (elapsed) ->
    super
    @rotation.z += @rotSpeed * @rotDirection * elapsed

  onBeat: (beat) ->
    new TWEEN.Tween(this)
      .to({rotSpeed: -@rotSpeed}, beat.duration.ms)
      .easing(TWEEN.Easing.Sinusoidal.InOut)
      .start()


class Strut extends Echotron.Echo
  uniformAttrs:
    color: 'c'
    twist: 'f'
    skew:  'f'
    glow:  'f'
    twistDir: 'f'
    bulge: 'v3'

  constructor: (@spiral, @angle, @flipped) ->
    super

    @angle *= 360.degToRad
    @widthScale = 0
    @glow = 0
    
    # snag shader props from parent
    {
      @color
      @twist
      @skew
      @bulge
    } = @spiral

    @twistDir = if @flipped then -1 else 1

    @geom = new THREE.PlaneGeometry(@spiral.width, 800, 1, 100)
    @twistVertices()

    @mesh = new THREE.Mesh(
      @geom
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        side: THREE.DoubleSide
        fragmentShader: assets["frag.glsl"]
        vertexShader:   assets['vert.glsl']
        transparent:    yes
        depthTest:      no
      )
    )

    @mesh.rotation.x = 90.degToRad
    @rotation.z = @angle

    @add @mesh

  update: (elapsed) ->
    @glow -= elapsed * 3
    @glow = 0 if @glow < 0

    if @active
      @widthScale += elapsed
      @widthScale = 1 if @widthScale > 1

    else
      @widthScale -= elapsed
      @widthScale = .001 if @widthScale < .001

    @scale.x = 1 - Math.pow(1 - @widthScale, 2)

  onSegment: (segment) ->
    return unless segment.pitches

    @strutStart ?= 0               + @angle / (2*Math.PI)
    @strutEnd   ?= 1 / @spiral.qty + @angle / (2*Math.PI)

    newGlow = _.max segment.pitches[Math.floor(@strutStart * 12)...Math.floor(@strutEnd * 12)]
    @glow = newGlow if newGlow > @glow

  alive: ->
    @widthScale > .001

  twistVertices: ->
    for vert in @geom.vertices
      depth = vert.y / 800 + 0.5
      swirl = Math.pow(depth, @skew) * @twist * @twistDir;
      vert.z = 80
      
      vert.set(
        (vert.x * Math.cos(swirl) - vert.z * Math.sin(swirl)) * (1 - depth)
        vert.y
        (vert.x * Math.sin(swirl) + vert.z * Math.cos(swirl)) * (1 - depth)
      )