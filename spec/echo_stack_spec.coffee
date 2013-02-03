describe 'EchoStack', ->
  describe 'constructor', ->
    it 'creates a LayerStack', ->
      echostack = new Echotron.EchoStack
      echostack.stack.should.be.instanceOf Echotron.LayerStack

  describe 'push', ->
    it 'adds echoes to the scene', ->
      echo1 = new Echotron.Echo
      echo2 = new Echotron.Echo

      echostack = new Echotron.EchoStack
      echostack.push echo1, echo2

      echostack.children.should.deep.equal [echo1, echo2]

    it 'pushes echoes to the stack', ->
      echo1 = new Echotron.Echo
      echo2 = new Echotron.Echo

      echostack = new Echotron.EchoStack
      echostack.push echo1, echo2

      echostack.stack.layers.should.deep.equal [echo1, echo2]

  describe 'song events', ->
    class Echo extends Echotron.Echo
      onBeat:    -> @beated = yes
      onBar:     -> @barred = yes
      onSegment: -> @segmented = yes
      onTatum:   -> @tatumed = yes

    echostack = null
    echo = null

    beforeEach ->
      echostack = new Echotron.EchoStack
      echo = new Echo
      echostack.push echo

    it 'delegates onBeat', ->
      echostack.onBeat {}
      echo.beated.should.be.true

    it 'delegates onBar', ->
      echostack.onBar {}
      echo.barred.should.be.true

    it 'delegates onSegment', ->
      echostack.onSegment {}
      echo.segmented.should.be.true

    it 'delegates onTatum', ->
      echostack.onTatum {}
      echo.tatumed.should.be.true

  describe 'kill', ->
    it 'kills all layers in the stack', ->
      echo1 = new Echotron.Echo
      echo2 = new Echotron.Echo
      echostack = new Echotron.EchoStack
      echostack.push echo1, echo2

      echostack.kill()

      echo1.active.should.be.false
      echo2.active.should.be.false

  describe 'update', ->
    class Echo extends Echotron.Echo
      update: (elapsed) -> @updated = elapsed

    it 'delegates to layers', ->
      echo1 = new Echo
      echo2 = new Echo
      echostack = new Echotron.EchoStack
      echostack.push echo1, echo2

      echostack.update 0.1

      echo1.updated.should.equal 0.1
      echo2.updated.should.equal 0.1

  describe 'alive', ->
    it 'returns true when there are layers in the stack', ->
      echostack = new Echotron.EchoStack
      echostack.push new Echotron.Echo
      echostack.alive().should.be.true

    it 'returns false when there are no layers in the stack', ->
      echostack = new Echotron.EchoStack
      echostack.alive().should.be.false