class Component.Rotator extends Component
  constructor: ({ @maxPitch, @maxRoll }) ->
    super

    @maxPitch ||= 30
    @maxRoll  ||= 60

    # [pitch, roll]
    strats = [
      [0, @maxRoll]
      [@maxPitch,  0]
      [0, 0]
      [@maxPitch, @maxRoll]
    ]

    strat = strats[THREE.Math.randInt(1, strats.length) - 1]
    @rotSpeed = new THREE.Vector2(
      strat[0] * Math.PI / 180
      strat[1] * Math.PI / 180
    )

  update: (elapsed) ->
    @obj.rotation.z += @rotSpeed.x * elapsed
    @obj.rotation.x += @rotSpeed.y * elapsed