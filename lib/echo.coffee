fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'

rootPath    = path.join path.dirname(fs.realpathSync(__filename)), '..'
echoesPath  = path.join rootPath, 'echoes'
currentPath = process.cwd()

# Compile an echo
exports.register = (app) ->
  app.get '/echoes/:echoType/:name.js', (req, res) ->
    res.type 'js'
    res.send compile(req.params.echoType, req.params.name)

exports.compile = compile = (echoType, name) ->
  # Search for a local echo direcotry
  echoPath = path.join currentPath, echoType, name

  # Then search for one in the framework
  unless fs.existsSync echoPath
    echoPath = path.join echoesPath, echoType, name
  
  files = fs.readdirSync echoPath
  code = null
  assets = {}

  for file in files
    if /^\./.test file
      continue

    else if file is 'main.coffee'
      mainPath = path.join echoPath, file
      coffeeCode = fs.readFileSync(mainPath).toString()

      try
        code = coffee.compile(coffeeCode, filename: path)
      catch e
        console.log e
        throw e
        return

    else if file is 'main.js'
      code = fs.readFileSync "#{echoPath}/#{file}"

    else
      assets[file] = fs.readFileSync("#{echoPath}/#{file}").toString()

  """
  (function() {
    var assets = #{JSON.stringify assets};
    var module = {};
    (function(){
      #{code}
    }.call({}));
    module.exports.id = "#{name}";
    window.Echotron.Echoes.#{echoType}.push(module.exports);
  }());
  """