fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'

rootPath = path.join path.dirname(fs.realpathSync(__filename)), '..'

# Compile coffeescript into JS.
exports.register = (app) ->
  app.get /^\/(js|spec)(.+?)\.js$/, (req, res) ->
    [dir, name] = req.params
    res.type 'js'
    fs.readFile path.join(rootPath, dir, "#{name}.coffee"), (err, data) ->
      try
        throw err if err
        res.send coffee.compile(data.toString(), filename: "#{dir}#{name}.coffee")
      catch e
        console.log "#{e}"
        res.status 500
        res.send 'Coffeescript Compilation Error'