fs = require 'fs'
coffee = require 'coffee-script'

# Compile an echo
exports.register = (app) ->
  app.get '/echoes/:echoType/:name.js', (req, res) ->
    res.type 'js'

    echoPath = "echoes/#{req.params.echoType}/#{req.params.name}"
    fs.readdir echoPath, (err, files) ->
      code = null
      assets = {}

      for file in files
        if /^\./.test file
          continue

        else if file is 'main.coffee'
          path = "#{echoPath}/#{file}"
          coffeeCode = fs.readFileSync(path).toString()

          try
            code = coffee.compile(coffeeCode, filename: path)
          catch e
            console.log e
            res.status 500
            res.send 'Coffeescript Compilation Error'
            return

        else if file is 'main.js'
          code = fs.readFileSync "#{echoPath}/#{file}"

        else
          assets[file] = fs.readFileSync("#{echoPath}/#{file}").toString()

      res.send(
        """
        (function() {
          var assets = #{JSON.stringify assets};
          var module = {};
          (function(){
            #{code}
          }.call({}));
          window.Echotron.Echoes.#{req.params.echoType}.push(module.exports);
        }());
        """
      )