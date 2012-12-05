fs = require 'fs'
coffee = require 'coffee-script'

# Compile coffeescript into JS.
exports.register = (app) ->
  app.get /^\/(js|spec)(.+?)\.js$/, (req, res) ->
    [dir, name] = req.params
    res.type 'js'
    fs.readFile "#{dir}#{name}.coffee", (err, data) ->
      try
        res.send coffee.compile(data.toString(), filename: "#{dir}#{name}.coffee")
      catch e
        console.log "#{e}"
        res.status 500
        res.send 'Coffeescript Compilation Error'