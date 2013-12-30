fs = require 'fs'
path = require 'path'

rootPath = path.join path.dirname(fs.realpathSync(__filename)), '..'
layersPath = path.join rootPath, 'layers'
currentPath = process.cwd()

layerTypes = [
  'background'
  'midground'
  'foreground'
]


module.exports =
  vendor: [
    'jquery'
    'three'
    'three_resize'
    'stats'
    'underscore'
    'backbone'
    'tweencurve'
    'tween'
    'sparks'
    'oculus_rift'
  ]
  app: [
    'layer'
    'util'
    'layer_group'
    'layer_stack'
    'music_cruncher'
    'song'
    'stage'
    'chrome_app'
  ]
  
  findLayers: (args...) ->
    if args.length is 2
      [onlyLocal, callback] = args

    else
      onlyLocal = false
      callback = args[0]

    layers = []

    # Find all framework echoes
    unless onlyLocal
      for layerType in layerTypes
        for layer in fs.readdirSync(path.join layersPath, layerType)
          continue if /^(\.|_)/.test layer
          layers.push "#{layerType}/#{layer}"

    # Find all local echoes
    if currentPath isnt rootPath
      for layerType in layerTypes
        typedDir = path.join currentPath, layerType
        if fs.existsSync typedDir
          for layer in fs.readdirSync(typedDir)
            continue if /^(\.|_)/.test layer
            layers.push "#{layerType}/#{layer}"

    callback null, layers

  findSpecs: (callback) ->
    fs.readdir path.join(rootPath, "spec"), (err, files) ->
      files =
        for file in files when /_spec/.test(file)
          file.replace /\.\w+?$/, ''

      callback err, files

  findSongs: (callback) ->
    fs.readdir path.join(rootPath, "songs"), (err, files) ->
      files =
        for file in files when not /.*\.json/.test(file) and not /^\./.test(file)
          file

      callback err, files