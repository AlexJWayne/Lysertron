module.exports = class Cubes extends Echotron.EchoStack
  constructor: ->
    super
    
    @size = [
      THREE.Math.randFloat(3, 8)
      THREE.Math.randFloat(3, 8)
    ]
    
    @type = 'Cube' #['Cube', 'Sphere'].random()
    @shader = ['lit', 'bright'].random()

    @spawnQty   = THREE.Math.randInt(5, 20)
    @shrinkTime = THREE.Math.randInt(3, 6) / stage.song.bps
    
    direction = [1, -1].random()
    @speed      = THREE.Math.randFloat(20, 50)  * -direction
    @accel      = THREE.Math.randFloat(50, 100) *  direction

    @roll   = [0, THREE.Math.randFloatSpread(180)].random().degToRad
    @tumble = [0, THREE.Math.randFloatSpread( 90)].random().degToRad

    @rotation.x = THREE.Math.randFloat(0, 360).degToRad
    @rotation.y = THREE.Math.randFloat(0, 360).degToRad
    @rotation.z = THREE.Math.randFloat(0, 360).degToRad

    @color = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), Math.random()

  beat: ->
    for i in [1..@spawnQty]
      @push new Cube this, color: @color, speed: @speed, accel: @accel, size: @size
    return

  bar: ->
    for i in [1..@spawnQty*4]
      @push new Cube this, color: @color, speed: Math.abs(@speed*2), accel: @accel, size: @size.map((s)-> s/3)
  
  update: (elapsed) ->
    super
    @rotation.z += @roll * elapsed
    @rotation.x += @tumble * elapsed


class Cube extends Echotron.Echo
  uniformAttrs:
    beatScale: 'f'
    tint:      'c'

  constructor: (@parentLayer, { @color, @speed, @accel, @size })->
    super

    @beatScale = 1
    @tint      = @color

    size = THREE.Math.randFloat @size...

    geom =
      if @parentLayer.type is 'Cube'
        new THREE.CubeGeometry size, size, size, 1, 1, 1
      else
        new THREE.SphereGeometry size/2, 16, 12

    @mesh = new THREE.Mesh(
      geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["scaler.vshader"]
        fragmentShader: assets["#{@parentLayer.shader}.fshader"]
      )
    )

    @add @mesh
    
    @mesh.position.set(
      THREE.Math.randFloatSpread 30
      THREE.Math.randFloatSpread 30
      THREE.Math.randFloatSpread 30
    )

    @accel = @accel
    @vel = @mesh.position.clone().setLength @speed

  alive: ->
    @uniforms.beatScale.value > 0

  update: (elapsed) ->
    @beatScale -= elapsed / @parentLayer.shrinkTime

    @vel.addSelf THREE.Vector3.temp(@mesh.position).setLength(@accel * elapsed)
    @mesh.position.addSelf THREE.Vector3.temp(@vel).multiplyScalar(elapsed)

    @kill() if @beatScale <= 0