describe 'Echo', ->
  describe 'constructor', ->

  describe 'uniformAttrs', ->
    class Specho extends Echotron.Echo
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

  describe 'kill', ->
    it 'sets @active to false', ->
      echo = new Echotron.Echo
      echo.kill()
      echo.active.should.be.false

  describe 'expired', ->
    class Specho extends Echotron.Echo
      constructor: ->
        super
        @hasBeer = yes

      alive: -> @hasBeer

    it 'returns true when @active and @alive()', ->
      echo = new Specho
      echo.expired().should.be.false

      echo.kill()
      echo.expired().should.be.false

    it 'returns false when not @active and not @alive()', ->
      echo = new Specho
      echo.expired().should.be.false

      echo.hasBeer = no
      echo.expired().should.be.false

      echo.kill()
      echo.expired().should.be.true

  describe 'alive', ->
    it 'simply returns @active, by default', ->
      echo = new Echotron.Echo
      echo.alive().should.be.true
      echo.kill()
      echo.alive().should.be.false

  it 'needs specs'