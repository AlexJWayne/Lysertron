fs = require 'fs'

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
    fs.readdir "echoes", (err, echoes) ->
      callback err, echoes

  findSpecs: (callback) ->
    fs.readdir "spec", (err, files) ->
      files =
        for file in files when /_spec/.test(file)
          file.replace /\.\w+?$/, ''

      callback err, files