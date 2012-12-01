fs = require 'fs'
coffee = require 'coffee-script'

# Compile coffeescript into JS.
exports.register = (app) ->
  app.get '/js/:name.js', (req, res) ->
    res.type 'js'
    fs.readFile "js/#{req.params.name}.coffee", (err, data) ->
      res.send coffee.compile(data.toString())