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

  describe 'dispatchMusicEvent', ->
    class Echo extends Echotron.Echo
      onMusicEvent: -> @musicEvented = yes
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

    it 'dispatches onMusicEvent', ->
      echostack.dispatchMusicEvent {}
      echo.musicEvented.should.be.true

    it 'dispatches onBeat', ->
      echostack.dispatchMusicEvent beat: {}
      echo.beated.should.be.true

    it 'dispatches onBar', ->
      echostack.dispatchMusicEvent bar: {}
      echo.barred.should.be.true

    it 'dispatches onSegment', ->
      echostack.dispatchMusicEvent segment: {}
      echo.segmented.should.be.true

    it 'dispatches onTatum', ->
      echostack.dispatchMusicEvent tatum: {}
      echo.tatumed.should.be.true

  describe '_kill', ->
    it 'kills all layers in the stack', ->
      echo1 = new Echotron.Echo
      echo2 = new Echotron.Echo
      echostack = new Echotron.EchoStack
      echostack.push echo1, echo2

      echostack._kill()

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