window.Layers ||=
  _shaders: {}

class Layers.Base extends THREE.Object3D
  components: {}

  constructor: (@scene) ->
    super

    @active = yes

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

  kill: ->
    @active = no

  expired: ->
    not @active and not @alive()

  # Override. Should return false when the layer can be destoryed.
  alive: -> @active

  # Override. Do stuff on beats.
  beat: ->

  # Override. Do stuff on bars.
  bar: ->

  # Override. Do stuff on segment.
  segment: ->

  # Override. Do stuff on bars.
  tatum: ->

  # Override, calling super. Update state per frame.
  update: (elapsed) ->
    component.update(elapsed) for component in @components
