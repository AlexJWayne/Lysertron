class Layers.Cubes extends Layers.Base
  constructor: (@scene) ->
    @cubes = []

  beat: ->
    @cubes.push new Layers.Cube(@scene)
  
  update: (elapsed) ->
    cube.update elapsed for cube in @cubes
    
    tempCubes = []
    for cube in @cubes
      if cube.expired
        @scene.remove cube.mesh
      else
        tempCubes.push cube

    @cubes = tempCubes
