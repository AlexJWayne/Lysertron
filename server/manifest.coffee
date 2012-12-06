fs = require 'fs'

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
    for echoType in echoTypes
      for echo in fs.readdirSync("echoes/#{echoType}")
        continue if /^\./.test echo
        echoes.push "#{echoType}/#{echo}"

    callback null, echoes

  findSpecs: (callback) ->
    fs.readdir "spec", (err, files) ->
      files =
        for file in files when /_spec/.test(file)
          file.replace /\.\w+?$/, ''

      callback err, files