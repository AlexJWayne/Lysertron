fs = require 'fs'
path = require 'path'

rootPath = path.join path.dirname(fs.realpathSync(__filename)), '..'
echoesPath = path.join rootPath, 'echoes'
currentPath = process.cwd()

echoTypes = [
  'background'
  'midground'
  'foreground'
]


module.exports =
  vendor: [
    'zepto'
    'three'
    'three_resize'
    'stats'
    'underscore'
    'backbone'
    'tweencurve'
    'tween'
    'sparks'
  ]
  app: [
    'echo'
    'util'
    'layer_stack'
    'echo_stack'
    'song'
    'stage'
  ]
  
  findEchoes: (callback) ->
    echoes = []

    # Find all framework echoes
    for echoType in echoTypes
      for echo in fs.readdirSync(path.join echoesPath, echoType)
        continue if /^(\.|_)/.test echo
        echoes.push "#{echoType}/#{echo}"

    # Find all local echoes
    if currentPath isnt rootPath
      for echoType in echoTypes
        typedDir = path.join currentPath, echoType
        if fs.existsSync typedDir
          for echo in fs.readdirSync(typedDir)
            continue if /^(\.|_)/.test echo
            echoes.push "#{echoType}/#{echo}"

    callback null, echoes

  findSpecs: (callback) ->
    fs.readdir path.join(rootPath, "spec"), (err, files) ->
      files =
        for file in files when /_spec/.test(file)
          file.replace /\.\w+?$/, ''

      callback err, files