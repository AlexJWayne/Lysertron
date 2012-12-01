fs = require 'fs'
coffee = require 'coffee-script'

# Compile an echo
exports.register = (app) ->
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