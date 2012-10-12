class window.Beat
  constructor: ({@bpm}) ->
    @bpm ||= 60
    @bps = @bpm / 60
    @timer =
      accurateInterval 1000/@bps, =>
        @trigger 'beat'
  
  _.extend @::, Backbone.Events