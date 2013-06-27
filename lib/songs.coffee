manifest = require './manifest'

exports.register = (app) ->
  app.get '/songs.json', (req, res) ->
    res.type 'json'

    manifest.findSongs (err, songs) ->
      res.send JSON.stringify songs
