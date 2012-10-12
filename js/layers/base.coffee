window.Layers ||=
  _shaders: {}

class Layers.Base
  constructor: (@scene) ->
    # ...
  
  getShader: (name) ->
    Layers._shaders[name] || (
      $.ajax
        url: "js/layers/#{name}"
        async: no
        success: (data) => Layers._shaders[name] = data
      Layers._shaders[name]
    )


  getMatProperties: (name) ->
    {
      vertexShader:   @getShader "#{name}.vshader"
      fragmentShader: @getShader "#{name}.fshader"
    }

  beat: ->
  update: (elapsed) ->
