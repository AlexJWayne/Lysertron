manifest = require './manifest'

# Index HTML
exports.register = (app) ->
  app.get '/', (req, res) ->
    manifest.findEchoes (err, echoes) ->
      res.render 'index.jade',
        vendor: manifest.vendor
        app:    manifest.app
        echoes: echoes
