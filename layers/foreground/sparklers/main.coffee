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
    influence = particle.position.length() / 100

    particle.velocity.sub(
      THREE.Vector3.temp(particle.position)
        .setLength(@force * time / influence)
    )


module.exports = class Sparkler extends Lysertron.Layer
  uniformAttrs:
    baseColor: 'c'
    darkening: 'f'

  initialize: ->
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

    @particlesPerBeat = 1000
    @particlesPerSegment = 20

    @counter = new SPARKS.ShotCounter @particlesPerBeat
    @emitter = new SPARKS.Emitter @counter
    
    @emitterZone = new MirrorPointZone(new THREE.Vector3 0, 0, 0)
    @emitter.addInitializer new SPARKS.Position(@emitterZone)
    @emitter.addInitializer new SPARKS.Velocity(new SphereZone(0, 0, 0, 70))
    @emitter.addInitializer new SPARKS.Lifetime .2, 1.5

    @emitter.addAction      new SPARKS.Age
    @emitter.addAction      new SPARKS.RandomDrift @drift, @drift, @drift
    @emitter.addAction      new SPARKS.Move
    @emitter.addAction      new Resistance 60
    @emitter.addAction      new Gravity 35

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
    @drift = 200#THREE.Math.randFloat 0, 500

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat 0, 1
      0.9
      1
    )

    @darkening = THREE.Math.randFloat 0.5, 3

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

  onMusicEvent: (event) ->
    if event.segment
      if @counter.used
        @counter.particles = @particlesPerSegment * event.segment.volume
        @counter.used = no

    else if event.bar
      # console.log @velocity
      @counter.particles = @particlesPerBeat * event.bar.volume
      @counter.used = no

    else if event.beat
      @counter.particles = @particlesPerBeat * event.beat.volume
      @counter.used = no

  alive: ->
    @emitter._particles.length > 0