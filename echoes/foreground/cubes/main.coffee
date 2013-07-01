module.exports = class Cubes extends Lysertron.LayerStack
  initialize: ->
    @size = [
      THREE.Math.randFloat(5, 16)
      THREE.Math.randFloat(5, 16)
    ]
    
    @shader = ['lit', 'bright'].random()

    @spawnQty   = THREE.Math.randInt(10, 50)
    @shrinkTime = THREE.Math.randFloat(2, 5) / stage.song.bps
    
    direction = [1, -1].random()
    @speed      = THREE.Math.randFloat(20, 50)  * -direction
    @accel      = THREE.Math.randFloat(50, 100) *  direction

    @roll   = [0, THREE.Math.randFloatSpread(180)].random().degToRad
    @tumble = [0, THREE.Math.randFloatSpread( 90)].random().degToRad

    @rotation.x = THREE.Math.randFloat(0, 360).degToRad
    @rotation.y = THREE.Math.randFloat(0, 360).degToRad
    @rotation.z = THREE.Math.randFloat(0, 360).degToRad

    @color = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), Math.random()

  onMusicEvent: (data) ->
    if data.bar
      for i in [1..@spawnQty*8]
        @push new Cube this,
          color: @color
          speed: Math.abs(@speed*2)
          accel: @accel/2
          size: @size.map((s)-> s/2)

    else if data.beat
      for i in [1..@spawnQty]
        @push new Cube this,
          color: @color
          speed: @speed
          accel: @accel
          size: @size
    
    return

  # onBeat: ->
  #   for i in [1..@spawnQty]
  #     @push new Cube this, color: @color, speed: @speed, accel: @accel, size: @size
  #   return

  # onBar: ->
  #   for i in [1..@spawnQty*8]
  #     @push new Cube this, color: @color, speed: Math.abs(@speed*2), accel: @accel/2, size: @size.map((s)-> s/2)
  #   return
  
  update: (elapsed) ->
    super
    @rotation.z += @roll * elapsed
    @rotation.x += @tumble * elapsed


class Cube extends Lysertron.Layer
  uniformAttrs:
    beatScale: 'f'
    tint:      'c'

  geom: new THREE.CubeGeometry 1, 1, 1, 1, 1, 1

  constructor: (@parentLayer, { @color, @speed, @accel, @size })->
    super

    @beatScale = 1
    new TWEEN.Tween(this)
      .to({beatScale: 0}, @parentLayer.shrinkTime * THREE.Math.randFloat(0.8, 1.2) * 1000)
      .start()

    @tint      = @color

    @finalSize = THREE.Math.randFloat @size...

    @mesh = new THREE.Mesh(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["scaler.vshader"]
        fragmentShader: assets["#{@parentLayer.shader}.fshader"]
      )
    )

    @add @mesh
    
    @mesh.position.set(
      THREE.Math.randFloatSpread 40
      THREE.Math.randFloatSpread 40
      THREE.Math.randFloatSpread 40
    )

    @vel = @mesh.position.clone().setLength @speed

  alive: ->
    @beatScale > 0

  update: (elapsed) ->
    # @beatScale -= elapsed / @parentLayer.shrinkTime
    @mesh.scale.setLength @finalSize * @beatScale * @beatScale

    @vel.add THREE.Vector3.temp(@mesh.position).setLength(@accel * elapsed)
    @mesh.position.add THREE.Vector3.temp(@vel).multiplyScalar(elapsed)
    
    @kill() if @beatScale <= 0