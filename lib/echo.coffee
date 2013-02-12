fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'
coffeeson = require 'coffeeson'

rootPath    = path.join path.dirname(fs.realpathSync(__filename)), '..'
echoesPath  = path.join rootPath, 'echoes'
currentPath = process.cwd()

# Compile an echo
exports.register = (app) ->
  app.get '/echoes/:echoType/:name.js', (req, res) ->
    res.type 'js'
    res.send compile(req.params.echoType, req.params.name)

exports.compileMeta = compileMeta = (echoType, name) ->
  echoPath = path.join currentPath, echoType, name
  echoPath = path.join echoesPath,  echoType, name unless fs.existsSync echoPath
  
  if fs.existsSync path.join(echoPath, 'meta.coffeeson')
    coffeeson.parse fs.readFileSync(path.join echoPath, 'meta.coffeeson')

  else if fs.existsSync(path.join echoPath, 'meta.json')
    JSON.parse fs.readFileSync(path.join echoPath, 'meta.json')

  else
    {}



exports.compile = compile = (echoType, name) ->
  # Search for a local echo directory.
  echoPath = path.join currentPath, echoType, name
  if fs.existsSync echoPath
    now = new Date()
    console.log "#{now.getHours()}:#{now.getMinutes()}:#{now.getSeconds()} - Sucessfully Compiled #{echoType}/#{name}"

  # If not found then search for one in the framework.
  else
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

    else if file is 'meta.coffeeson'
      meta = coffeeson.parse fs.readFileSync("#{echoPath}/#{file}")

    else if file is 'meta.json'
      meta = JSON.parse fs.readFileSync("#{echoPath}/#{file}")

    else
      assets[file] = fs.readFileSync("#{echoPath}/#{file}").toString()

  """
  (function() {
    var assets = #{JSON.stringify assets};
    var module = {};
    (function(){
      #{code}
    }.call({}));
    module.exports._id = "#{name}";
    module.exports._meta = #{JSON.stringify compileMeta(echoType, name)};
    window.Echotron.Echoes.#{echoType}.push(module.exports);
  }());
  """