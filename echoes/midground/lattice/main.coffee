module.exports = class Lattice extends Echotron.EchoStack
  constructor: ->
    super

    @flipped = [yes, no].random()
    @doubled = [yes, no].random()

    @time = THREE.Math.randFloat(1, 360).rad
    @offset = THREE.Math.randFloat(1, 4).rad
    @offsetSpeed = THREE.Math.randFloat(30, 130).rad
    @offsetShape = [
      THREE.Math.randFloat(0.5, 1)
      THREE.Math.randFloat(1,   2)
    ].random()
    
    @position.z = 750

    @spiral1 = new Spiral @flipped
    @push @spiral1

    if @doubled
      @spiral2 = new Spiral !@flipped, @spiral1
      @push @spiral2


  update: (elapsed) ->
    super
    @time += elapsed
    @rotation.z = @time

    @rotation.x = @offset * Math.cos(@time * @offsetSpeed / @offsetShape)
    @rotation.y = @offset * Math.sin(@time * @offsetSpeed / (1 / @offsetShape))



class Spiral extends Echotron.EchoStack
  constructor: (@flipped, source = {}) ->
    super

    @color = source.color || new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0.6, 1)
    )
    @qty   = source.qty   || THREE.Math.randInt 3, 15
    @width = source.width || THREE.Math.randFloat(80, 300) / @qty
    @twist = source.twist || THREE.Math.randFloat 2, 12
    @skew  = source.skew  || [1, 3].random()

    @flippedDir = if @flipped then -1 else 1

    @rotDirection   = source.rotDirection   || [1, -1].random()
    @rotSpeedTarget = source.rotSpeedTarget || THREE.Math.randFloat(20, 50).rad
    @rotSpeedDecay  = source.rotSpeedDecay  || @rotSpeedTarget * @rotDirection * 8
    @rotSpeed       = 0

    @push (new Strut(this, i/@qty, @flipped) for i in [0...@qty])...

    @position.z = -400 + @rotDirection * 25

  setSkew: (@skew) ->
    for layer in @stack.layers
      layer.skew = @skew

  update: (elapsed) ->
    super

    @rotSpeed -= @rotSpeedDecay * @rotDirection * @flippedDir * elapsed / stage.song.bps
    @rotSpeed  = @rotSpeedTarget  * 3 if @rotSpeed >  @rotSpeedTarget * 3
    @rotSpeed  = -@rotSpeedTarget * 3 if @rotSpeed < -@rotSpeedTarget * 3

    @rotation.z += @rotSpeed      * @rotDirection * elapsed / stage.song.bps

  beat: ->
    @rotSpeed = @rotSpeedTarget

class Strut extends Echotron.Echo
  uniformAttrs:
    color: 'c'
    twist: 'f'
    skew:  'f'
    twistDir: 'f'

  constructor: (@lattice, @angle, @flipped) ->
    super

    @angle *= 360.rad
    
    # snag shader props from parent
    {
      @color
      @twist
      @skew
    } = @lattice

    @twistDir = if @flipped then -1 else 1

    @geom = new THREE.PlaneGeometry(@lattice.width, 800, 1, 100)
    @twistVertices()

    @mesh = new THREE.Mesh(
      @geom
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        side: THREE.BackSide
        fragmentShader: assets["frag.glsl"]
        vertexShader: assets['vert.glsl']
        transparent: yes
        depthTest: no
      )
    )

    @mesh.rotation.x = 90.rad
    @rotation.z = @angle

    @add @mesh

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