class CubeStack extends Echotron.Echo
  constructor: (@scene) ->
    super

    @cubes = new Echotron.LayerStack
    
    @size = [
      THREE.Math.randFloat(5, 12)
      THREE.Math.randFloat(5, 12)
    ]
    
    @type = 'Cube' #['Cube', 'Sphere'].random()
    @shader = ['lit', 'bright'].random()

    @spawnQty   = THREE.Math.randInt(3, 8)
    @shrinkTime = THREE.Math.randInt(3, 6) / @scene.song.bps
    
    direction = [1, -1].random()
    @speed      = THREE.Math.randFloat(20, 50)  * -direction
    @accel      = THREE.Math.randFloat(50, 100) *  direction

    @roll   = [0, THREE.Math.randFloatSpread(180)].random() * Math.PI/180
    @tumble = [0, THREE.Math.randFloatSpread( 90)].random() * Math.PI/180
    @rotation.y = THREE.Math.randFloat(0, 360)              * Math.PI/180

    @color = new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), Math.random()

  beat: ->
    for i in [1..@spawnQty]
      cube = new Cube this, color: @color, speed: @speed, accel: @accel, size: @size
      @add cube
      @cubes.push cube
    return

  bar: ->
    for i in [1..@spawnQty*5]
      cube = new Cube this, color: @color, speed: Math.abs(@speed*2), accel: @accel, size: @size.map((s)-> s/3)
      @add cube
      @cubes.push cube
  
  update: (elapsed) ->
    @rotation.z += @roll * elapsed
    @rotation.x += @tumble * elapsed
    @cubes.update elapsed
    
  alive: -> !@cubes.isEmpty()


class Cube extends Echotron.Echo
  uniformAttrs:
    beatScale: 'f'
    tint:      'c'

  constructor: (@parent, { @color, @speed, @accel, @size })->
    super

    @beatScale = 1
    @tint      = @color

    size = THREE.Math.randFloat @size...

    geom =
      if @parent.type is 'Cube'
        new THREE.CubeGeometry size, size, size, 1, 1, 1
      else
        new THREE.SphereGeometry size/2, 16, 12

    @mesh = new THREE.Mesh(
      geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["scaler.vshader"]
        fragmentShader: assets["#{@parent.shader}.fshader"]
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
    @beatScale -= elapsed / @parent.shrinkTime

    @vel.addSelf @mesh.position.clone().setLength(@accel * elapsed)
    @mesh.position.addSelf @vel.clone().multiplyScalar(elapsed)

    @kill() if @beatScale <= 0

@Main = CubeStack