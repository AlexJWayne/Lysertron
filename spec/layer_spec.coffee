describe 'Layer', ->
  describe 'constructor', ->
    class Specho extends Lysertron.Layer
      initialize: ->
        @initialized = yes

    it 'calls the initialize()', ->
      echo = new Specho
      echo.initialized.should.be.true

  describe 'uniformAttrs', ->
    class Specho extends Lysertron.Layer
      uniformAttrs:
        beer: 'f'

    it 'creates a getter', ->
      echo = new Specho
      echo.uniforms.beer.value = 99
      echo.beer.should.equal 99

    it 'creates a setter', ->
      echo = new Specho
      echo.beer = 14
      echo.uniforms.beer.value.should.equal 14

    it 'creates a typed object under @uniforms', ->
      echo = new Specho
      echo.beer = 37

      echo.uniforms.beer.should.deep.equal value: 37, type: 'f'

  describe '_kill', ->
    it 'sets @active to false', ->
      echo = new Lysertron.Layer
      echo._kill()
      echo.active.should.be.false

    it 'calls kill()', ->
      class Specho extends Lysertron.Layer
        kill: -> @killed = yes

      echo = new Specho
      echo._kill()
      echo.killed.should.be.true
        
    
    

  describe 'expired', ->
    class Specho extends Lysertron.Layer
      constructor: ->
        super
        @hasBeer = yes

      alive: -> @hasBeer

    it 'returns true when @active and @alive()', ->
      echo = new Specho
      echo.expired().should.be.false

      echo._kill()
      echo.expired().should.be.false

    it 'returns false when not @active and not @alive()', ->
      echo = new Specho
      echo.expired().should.be.false

      echo.hasBeer = no
      echo.expired().should.be.false

      echo._kill()
      echo.expired().should.be.true

  describe 'alive', ->
    it 'simply returns @active, by default', ->
      echo = new Lysertron.Layer
      echo.alive().should.be.true
      echo._kill()
      echo.alive().should.be.false