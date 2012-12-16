describe 'Stage', ->
  describe 'getHandlerName', ->
    it 'translates an event name to a standardized handler name', ->
      stage.getHandlerName('foo').should == 'onFoo'
      stage.getHandlerName('omgWtf').should == 'onOmgWtf'
      stage.getHandlerName('segment').should == 'onSegment'

  it 'needs specs'