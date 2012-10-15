window.Layers ||=
  _shaders: {}

class Layers.Base extends THREE.Object3D
  components: {}

  constructor: (@scene) ->
    super

    @components =
      for own name, args of @components
        component = new Component[name](args || {})
        component.obj = this
        component

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
    component.update(elapsed) for component in @components
