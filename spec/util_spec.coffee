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

  describe 'THREE.Vector3.temp()', ->
    it 'always returns the same object', ->
      v1 = THREE.Vector3.temp()
      v2 = THREE.Vector3.temp()
      v1.should.be.equal v2

    it 'accepts a vector to copy', ->
      v = new THREE.Vector3 1, 2, 3
      THREE.Vector3.temp(v).x.should.equal 1
      THREE.Vector3.temp(v).y.should.equal 2
      THREE.Vector3.temp(v).z.should.equal 3

    it 'accepts a single float to use as all 3 values', ->
      v = THREE.Vector3.temp(9)
      v.x.should.equal 9
      v.y.should.equal 9
      v.z.should.equal 9

    it 'accepts 3 floats to use for x, y, and z', ->
      v = THREE.Vector3.temp(7,8,9)
      v.x.should.equal 7
      v.y.should.equal 8
      v.z.should.equal 9

  describe 'Number::degToRad', ->
    it "returns the radian value of this number, assuming it's in degrees", ->
      180.degToRad.should.equal Math.PI
  
  describe 'Number::radToDeg', ->
    it "returns the degree value of this number, assuming it's in radians", ->
      Math.PI.radToDeg.should.equal 180

  describe 'Number::ms', ->
    it "returns milliseconds, assuming its in seconds", ->
      6.ms.should == 6000