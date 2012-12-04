fs = require 'fs'
coffee = require 'coffee-script'

# Compile coffeescript into JS.
exports.register = (app) ->
  app.get /^\/(js|spec)(.+?)\.js$/, (req, res) ->
    [dir, name] = req.params
    res.type 'js'
    fs.readFile "#{dir}/#{name}.coffee", (err, data) ->
      res.send coffee.compile(data.toString())