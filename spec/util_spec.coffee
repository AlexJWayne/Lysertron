describe 'Utils', ->
  describe 'Array::random()', ->

    # Don't destory the built in Math.random()
    oldRnd = Math.random
    after -> Math.random = oldRnd

    it 'returns a random element', ->
      Math.random = -> 0
      [1,2,3].random().should.equal 1

      Math.random = -> 0.49
      [1,2,3].random().should.equal 2

      Math.random = -> 0.99
      [1,2,3].random().should.equal 3