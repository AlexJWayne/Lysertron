describe 'LayerStack', ->
  describe 'constructor', ->
    it 'creates @layers as an empty array by default', ->
      stack = new Echotron.LayerStack
      stack.layers.should.deep.equal []

    it 'accepts an array of layers to populate @layers', ->
      echo = new Echotron.Echo
      stack = new Echotron.LayerStack [echo]
      stack.layers.should.deep.equal [echo]

  describe 'song events', ->
    describe 'delegates to each layer', ->
      class Specho extends Echotron.Echo
        beat: -> @beated = yes
        bar: -> @barred = yes
        segment: -> @segmented = yes
        tatum: -> @tatumed = yes

      echo1 = null
      echo2 = null
      stack = null

      beforeEach ->
        echo1 = new Specho
        echo2 = new Specho
        stack = new Echotron.LayerStack [echo1, echo2]
    
      it 'on beat', ->
        stack.beat()
        echo1.beated.should.be.true
    
      it 'on bar', ->
        stack.bar()
        echo1.barred.should.be.true
    
      it 'on segment', ->
        stack.segment()
        echo1.segmented.should.be.true
    
      it 'on tatum', ->
        stack.tatum()
        echo1.tatumed.should.be.true

  describe 'update()', ->
    it 'calls update on each layer', ->
      class Specho extends Echotron.Echo
        update: (elapsed) ->
          @updated = yes

      echo1 = new Specho
      echo2 = new Specho
      stack = new Echotron.LayerStack [echo1, echo2]

      stack.update()

      echo1.updated.should.be.true
      echo2.updated.should.be.true

    it 'removes expired layers', ->
      class Specho extends Echotron.Echo
        constructor: (@isExpired) -> super
        expired: -> @isExpired

      echo1 = new Specho no
      echo2 = new Specho yes
      stack = new Echotron.LayerStack [echo1, echo2]
      stack.update()

      stack.layers.should.deep.equal [echo1]

  describe 'push()', ->
    it 'adds a layer to @layers', ->
      stack = new Echotron.LayerStack
      echo = new Echotron.Echo
      stack.push echo
      stack.layers.should.deep.equal [echo]

    it 'throws exception if a non Echotron.Echo object is pushed', ->
      stack = new Echotron.LayerStack
      obj = {}
      (-> stack.push obj).should.throw "LayerStack#push: object is not a Echotron.Echo"

  describe 'isEmpty()', ->
    it 'returns false when there are layers', ->
      stack = new Echotron.LayerStack(new Echotron.Echo)
      stack.isEmpty().should.be.false

    it 'returns true when there are no layers', ->
      stack = new Echotron.LayerStack
      stack.isEmpty().should.be.true

  describe 'transition()', ->
    it 'needs specs'






