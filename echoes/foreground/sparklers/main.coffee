hideVector = (v) ->
  v.set 0, 0, 0

class MirrorPointZone
  constructor: (@pos) ->
  getLocation: ->
    which = [1, -1].random()
    SPARKS.VectorPool.get()
      .copy(@pos)
      .multiplyScalar(which)

class SphereZone
  constructor: (@x, @y, @z, @maxr) ->
  getLocation: ->
    v = SPARKS.VectorPool.get().set(1,1,1)
    until v.length() <= 1
      v.set(
        THREE.Math.randFloatSpread -1, 1
        THREE.Math.randFloatSpread -1, 1
        THREE.Math.randFloatSpread -1, 1
      )

    v.setLength @maxr

class Resistance
  constructor: (@amount) ->
  update: (emitter, particle, time) ->
    v = particle.velocity
    return if v.length() is 0

    amount = @amount * time
    if amount < v.length()
      v.setLength v.length() - amount
    else
      v.setLength 0

class Gravity
  constructor: (@force) ->
  update: (emitter, particle, time) ->
    distSquare = Math.pow particle.position.length(), 2
    distSquare = particle.position.length()

    particle.velocity.subSelf(
      THREE.Vector3.temp(particle.position)
        .setLength(@force * time / distSquare)
    )
    

module.exports = class Sparkler extends Echotron.Echo
  uniformAttrs:
    baseColor: 'c'
    darkening: 'f'

  constructor: ->
    super

    @setupValues()

    @vertexAttributes =
      energy:
        type: 'f'
        value: []

    @lastParticleIndex = 0
    @geom = new THREE.Geometry
    for i in [0...6000]
      @geom.vertices.push new THREE.Vector3(0, 0, 0)
      @vertexAttributes.energy.value.push 0

    @particlesPerBeat = 1500
    @particlesPerSegment = 20

    @counter = new SPARKS.ShotCounter @particlesPerBeat
    @emitter = new SPARKS.Emitter @counter
    
    @emitterZone = new MirrorPointZone(new THREE.Vector3 0, 0, 0)
    @emitter.addInitializer new SPARKS.Position(@emitterZone)
    @emitter.addInitializer new SPARKS.Velocity(new SphereZone(0, 0, 0, 50))
    @emitter.addInitializer new SPARKS.Lifetime .4, 1.25

    @emitter.addAction      new SPARKS.Age
    @emitter.addAction      new SPARKS.RandomDrift @drift, @drift, @drift
    @emitter.addAction      new SPARKS.Move
    @emitter.addAction      new Resistance 40
    @emitter.addAction      new Gravity 2000

    @emitter.addCallback "created", @onParticleCreated
    @emitter.addCallback "dead",    @onParticleDead


    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        attributes:     @vertexAttributes
        vertexShader:   assets['vert.glsl']
        fragmentShader: assets['frag.glsl']
        transparent:    yes
        depthTest:      no
      )
    )
    @particles.sortParticles = yes
    @add @particles

    @queuePositionAnimation()

    @emitter.start()

  setupValues: ->
    @drift = THREE.Math.randFloat 0, 500

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      0.9
      1
    )

    @darkening = THREE.Math.randFloat 0.5, 3
    console.log @darkening

  onParticleCreated: (p) =>
    console.log "Exceeded Particle max! #{@emitter._particles.length}" if @emitter._particles.length > @geom.vertices.length
    @lastParticleIndex = 0 if @lastParticleIndex >= @geom.vertices.length
    p.target = @lastParticleIndex++

  onParticleDead: (p) =>
    hideVector @geom.vertices[p.target]
    @vertexAttributes.energy.value[p.target] = 0

  queuePositionAnimation: ->
    zone = new SphereZone 0, 0, 0, 30
    positions = x: [], y: [], z: []
    for i in [0...10]
      pos = zone.getLocation()
      positions.x.push pos.x
      positions.y.push pos.y
      positions.z.push pos.z

    @emitterZone.pos.copy zone.getLocation()

    new TWEEN.Tween(@emitterZone.pos)
      .to(positions, 20.ms)
      .interpolation(TWEEN.Interpolation.CatmullRom)
      .start()

  update: (elapsed) ->
    super
    for p in @emitter._particles
      @geom.vertices[p.target].copy p.position
      @vertexAttributes.energy.value[p.target] = p.energy

  onBeat: ->
    @counter.particles = @particlesPerBeat
    @counter.used = no

  onSegment: ->
    if @counter.used
      @counter.particles = @particlesPerSegment
      @counter.used = no

  alive: ->
    @emitter._particles.length > 0