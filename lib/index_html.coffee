path = require 'path'
fs   = require 'fs'
indexPath = path.join path.dirname(fs.realpathSync(__filename)), '../index.jade'

manifest = require './manifest'

# Index HTML

renderContent = (req, res, { specRun, specs }) ->
  specs ||= []

  manifest.findLayers (err, layers) ->
    res.render indexPath,
      vendor:   manifest.vendor
      app:      manifest.app
      specs:    specs
      layers:   layers
      specRun:  specRun

exports.register = (app) ->
  app.get '/', (req, res) ->
    renderContent req, res, specRun: no

  app.get '/spec', (req, res) ->
    manifest.findSpecs (err, specs) ->
      renderContent req, res, specRun: yes, specs: specs