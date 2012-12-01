fs = require 'fs'

module.exports =
  vendor: [
    'zepto'
    'three'
    'stats'
    'underscore'
    'backbone'
    'tweencurve'
  ]
  app: [
    'echo'
    'util'
    'song'
    'layer_stack'
    'stage'
  ]
  findEchoes: (callback) ->
    fs.readdir "echoes", (err, echoes) ->
      callback err, echoes
