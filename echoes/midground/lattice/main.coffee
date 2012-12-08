module.exports = class Lattice extends Echotron.EchoStack
  constructor: ->
    super

    @flipped = [yes, no].random()
    @doubled = [yes, no].random()

    @spiral1 = new Spiral @flipped
    @push @spiral1

    if @doubled
      console.log 'doubled'
      @spiral2 = new Spiral !@flipped, @spiral1
      @push @spiral2



class Spiral extends Echotron.EchoStack
  constructor: (@flipped, source = {}) ->
    super

    @color = source.color || new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0.6, 1)
    )
    @qty   = source.qty   || THREE.Math.randInt 5, 12
    @width = source.width || THREE.Math.randFloat(40, 175) / @qty
    @twist = source.twist || THREE.Math.randFloat 2, 12
    @skew  = source.skew  || [1, 3].random()

    @flippedDir = if @flipped then -1 else 1

    @rotDirection   = source.rotDirection   || [1, -1].random()
    @rotSpeedTarget = source.rotSpeedTarget || THREE.Math.randFloat(20, 75).rad
    @rotSpeedDecay  = source.rotSpeedDecay  || @rotSpeedTarget * THREE.Math.randFloat(4, 12)
    @rotSpeed       = 0


    @push (new Strut(this, i/@qty, @flipped) for i in [0...@qty])...

  setSkew: (@skew) ->
    for layer in @stack.layers
      layer.skew = @skew

  update: (elapsed) ->
    super

    @rotSpeed   -= @rotSpeedDecay * @rotDirection * @flippedDir * elapsed / stage.song.bps
    @rotation.z += @rotSpeed      * @rotDirection * elapsed / stage.song.bps

  beat: ->
    console.log 'before', @rotSpeed
    @rotSpeed = @rotSpeedTarget
    console.log 'after', @rotSpeed

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

    @mesh = new THREE.Mesh(
      new THREE.PlaneGeometry(@lattice.width, 800, 1, 100)
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        side: THREE.BackSide
        wireframe: no
        fragmentShader: assets["frag.glsl"]
        vertexShader: assets['vert.glsl']
        transparent: yes
        depthWrite: no
      )
    )

    @mesh.rotation.x = 90.rad
    @rotation.z = @angle

    @mesh.position.z = 400
    @mesh.position.y = -75

    @add @mesh