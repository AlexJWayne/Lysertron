describe 'LayerStack', ->
  scene = null

  beforeEach ->
    scene = new THREE.Scene

  describe 'constructor', ->
    it 'creates @layers as an empty array by default', ->
      stack = new Lysertron.LayerStack scene
      stack.layers.should.deep.equal []

    it 'accepts an array of layers to populate @layers', ->
      echo = new Lysertron.Echo
      stack = new Lysertron.LayerStack scene, [echo]
      stack.layers.should.deep.equal [echo]

  describe 'dispatchMusicEvent', ->
    describe 'delegates to each layer', ->
      class Specho extends Lysertron.Echo
        onMusicEvent: ->
          @triggered = yes

      echo1 = null
      echo2 = null
      stack = null

      beforeEach ->
        echo1 = new Specho
        echo2 = new Specho
        stack = new Lysertron.LayerStack scene, [echo1, echo2]
    
      it 'onBeat', ->
        stack.dispatchMusicEvent event: 'data'
        echo1.triggered.should.be.true
        echo2.triggered.should.be.true

  describe 'update', ->
    it 'calls update on each layer', ->
      class Specho extends Lysertron.Echo
        update: (elapsed) ->
          @updated = yes

      echo1 = new Specho
      echo2 = new Specho
      stack = new Lysertron.LayerStack scene, [echo1, echo2]

      stack.update()

      echo1.updated.should.be.true
      echo2.updated.should.be.true

    it 'removes expired layers', ->
      class Specho extends Lysertron.Echo
        constructor: (@isExpired) -> super
        expired: -> @isExpired

      echo1 = new Specho no
      echo2 = new Specho yes
      stack = new Lysertron.LayerStack scene, [echo1, echo2]
      stack.update()

      stack.layers.should.deep.equal [echo1]

  describe 'push', ->
    it 'adds a layer to @layers', ->
      stack = new Lysertron.LayerStack
      echo = new Lysertron.Echo
      stack.push echo
      stack.layers.should.deep.equal [echo]

    it 'throws exception if a non Lysertron.Echo object is pushed', ->
      stack = new Lysertron.LayerStack
      obj = {}
      (-> stack.push obj).should.throw "LayerStack::push() object is not a Lysertron.Echo"

  describe 'isEmpty', ->
    it 'returns false when there are layers', ->
      stack = new Lysertron.LayerStack scene, new Lysertron.Echo
      stack.isEmpty().should.be.false

    it 'returns true when there are no layers', ->
      stack = new Lysertron.LayerStack scene
      stack.isEmpty().should.be.true

  describe 'transition', ->
    it 'needs specs'






