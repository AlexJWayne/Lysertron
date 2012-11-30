path = require 'path'
fs   = require 'fs'
coffee = require 'coffee-script'

express = require 'express'
app = express()

# Static dirs
app.use '/js',    express.static('js')
app.use '/songs', express.static('songs')

# Index HTML
app.get '/', (req, res) -> res.sendfile 'index.html'

app.get '/js/:name.js', (req, res) ->
  res.type 'js'
  fs.readFile "js/#{req.params.name}.coffee", (err, data) ->
    res.send coffee.compile(data.toString())

# echoes
app.get '/echoes/:name.js', (req, res) ->
  res.type 'js'
  fs.readdir "echoes/#{req.params.name}", (err, files) ->
    code = null
    assets = {}

    for file in files
      if /^\./.test file
        continue

      else if file is 'main.coffee'
        coffeeCode = fs.readFileSync("echoes/#{req.params.name}/#{file}").toString()
        code = coffee.compile coffeeCode

      else if file is 'main.js'
        code = fs.readFileSync "echoes/#{req.params.name}/#{file}"

      else
        assets[file] = fs.readFileSync("echoes/#{req.params.name}/#{file}").toString()

    res.send  """
              (function() {
                var assets = #{JSON.stringify assets};
                var __ctx = {};
                (function(){
                  #{code}
                }.call(__ctx));
                window.Echotron.Echoes.#{req.params.name} = __ctx.Main;
              }());
              """

# Start Server
console.log "Started server on port 3000"
app.listen 3000