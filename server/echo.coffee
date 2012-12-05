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
          path = "echoes/#{req.params.name}/#{file}"
          coffeeCode = fs.readFileSync(path).toString()

          try
            code = coffee.compile(coffeeCode, filename: path)
          catch e
            console.log e
            res.status 500
            res.send 'Coffeescript Compilation Error'
            return

        else if file is 'main.js'
          code = fs.readFileSync "echoes/#{req.params.name}/#{file}"

        else
          assets[file] = fs.readFileSync("echoes/#{req.params.name}/#{file}").toString()

      res.send(
        """
        (function() {
          var assets = #{JSON.stringify assets};
          var module = {};
          (function(){
            #{code}
          }.call({}));
          window.Echotron.Echoes.#{req.params.name} = module.exports;
        }());
        """
      )