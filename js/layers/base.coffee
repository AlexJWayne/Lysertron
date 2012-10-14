window.Layers ||=
  _shaders: {}

class Layers.Base extends THREE.Object3D
  constructor: (@scene) ->
    super
    @scene.add this
  
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
