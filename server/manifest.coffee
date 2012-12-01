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
    'layer_stack'
    'echo_stack'
    'song'
    'stage'
  ]
  findEchoes: (callback) ->
    fs.readdir "echoes", (err, echoes) ->
      callback err, echoes
