fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'
coffeeson = require 'coffeeson'

rootPath    = path.join path.dirname(fs.realpathSync(__filename)), '..'
layersPath  = path.join rootPath, 'layers'
currentPath = process.cwd()

# Compile a layer class
exports.register = (app) ->
  app.get '/layers/:layerType/:name.js', (req, res) ->
    res.type 'js'
    res.send compile(req.params.layerType, req.params.name)

exports.compileMeta = compileMeta = (layerType, name) ->
  layerPath = path.join currentPath, layerType, name
  layerPath = path.join layersPath,  layerType, name unless fs.existsSync layerPath
  
  if fs.existsSync path.join(layerPath, 'meta.coffeeson')
    coffeeson.parse fs.readFileSync(path.join layerPath, 'meta.coffeeson')

  else if fs.existsSync(path.join layerPath, 'meta.json')
    JSON.parse fs.readFileSync(path.join layerPath, 'meta.json')

  else
    {}



exports.compile = compile = (layerType, name) ->
  
  # Search for a local layer directory.
  layerPath = path.join currentPath, layerType, name
  if fs.existsSync layerPath
    now = new Date()
    console.log "#{now.getHours()}:#{now.getMinutes()}:#{now.getSeconds()} - Sucessfully Compiled #{layerType}/#{name}"

  # If not found then search for one in the framework.
  else
    layerPath = path.join layersPath, layerType, name
  
  files = fs.readdirSync layerPath
  code = null
  assets = {}

  for file in files
    if /^\./.test file
      continue

    else if file is 'main.coffee'
      mainPath = path.join layerPath, file
      coffeeCode = fs.readFileSync(mainPath).toString()

      try
        code = coffee.compile(coffeeCode, filename: path)
      catch e
        console.log e
        throw e
        return

    else if file is 'main.js'
      code = fs.readFileSync "#{layerPath}/#{file}"

    else if file is 'meta.coffeeson'
      meta = coffeeson.parse fs.readFileSync("#{layerPath}/#{file}")

    else if file is 'meta.json'
      meta = JSON.parse fs.readFileSync("#{layerPath}/#{file}")

    else
      assets[file] = fs.readFileSync("#{layerPath}/#{file}").toString()

  """
  (function() {
    var assets = #{JSON.stringify assets};
    var module = {};
    (function(){
      #{code}
    }.call({}));
    module.exports._id = "#{name}";
    module.exports._meta = #{JSON.stringify compileMeta(layerType, name)};
    window.Lysertron.Layers.#{layerType}.push(module.exports);
  }());
  """