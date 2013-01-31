module.exports = class Terrains extends Echotron.EchoStack

  constructor: ->
    super

    @bottom = new Terrain
    @top    = new Terrain
    @top.rotation.z = 180.degToRad

    @push @bottom
    @push @top

class Terrain extends Echotron.Echo
  uniformAttrs:
    smoothness: 'f'
    travel: 'v2'
    maxHeight: 'f'
    beatValue: 'f'
    baseColor: 'c'

  geom: new THREE.PlaneGeometry 1500, 1000, 150, 100

  constructor: ->
    super

    @undulation    = THREE.Math.randFloat 0.5, 1.5
    @smoothness    = THREE.Math.randFloat 125, 300
    @maxHeight     = THREE.Math.randFloat 75, 160
    @baseColor     = new THREE.Color().setHSV(
      Math.random()
      THREE.Math.randFloat 0.5, 1
      1
    )
    @travelSpeed = new THREE.Vector2(
      [0, THREE.Math.randFloat(0, 0.2)]
    )

    @travel = new THREE.Vector2(
      Math.random() * 100
      Math.random() * 100
    )
    @beatValue = 1

    @terrain = new THREE.Mesh(
      @geom
      new THREE.ShaderMaterial(
        uniforms: @uniforms
        vertexShader: assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
      )
    )

    @terrain.rotation.x = -90.degToRad
    @terrain.position.y = -200
    @terrain.position.z = 500

    @add @terrain

  update: (elapsed) ->
    @beatValue -= elapsed * 2
    @beatValue = 0 if @beatValue < 0
    
    @travel.y -= @undulation * elapsed

  onBeat: ->
    @beatValue = 1

  kill: ->
    super
    new TWEEN.Tween(@terrain.position)
      .to({y: -1010}, 3.ms)
      .easing(TWEEN.Easing.Quadratic.In)
      .start()

  alive: ->
    @terrain.position.y > -1000