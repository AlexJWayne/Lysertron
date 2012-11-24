assert   = require 'assert'
vows     = require 'vows'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

vows.describe('playlist methods').addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to create a basic artist-radio playlist from behold... the arctopus":
      topic: (nest) ->
        nest.playlist.basic {
          artist: "behold... the arctopus"
          type: "artist-radio"
        }, @callback
        undefined
      'i get some tunes': (err, response) ->
        assert.ok response.songs.length > 1
      'we see no errors': checkErrors
    "to create a static artist-radio playlist from behold... the arctopus":
      topic: (nest) ->
        nest.playlist.basic {
          artist: "behold... the arctopus"
          type: "artist-radio"
        }, @callback
        undefined
      'i get some tunes': (err, response) ->
        assert.ok response.songs.length > 1
      'we see no errors': checkErrors
    "to create a dynamic artist-radio playlist from behold... the arctopus":
      topic: (nest) ->
        nest.playlist.dynamic {
          artist: "behold... the arctopus"
          type: "artist-radio"
        }, @callback
        undefined
      'i get a tune': (err, response) ->
        assert.ok response.songs.length == 1
      'I can resume my session':
        topic: (response, nest) ->
          nest.playlist.dynamic {
            session_id: response.session_id
          }, @callback
        'and get another tune': (err, response) ->
          assert.ok response.songs.length == 1
      'I can get session_info on my session':
        topic: (response, nest) ->
          nest.playlist.session_info {
            session_id: response.session_id
          }, @callback
        'and there are no skipped songs': (err, response) ->
          assert.isEmpty response.skipped_songs
      'we see no errors': checkErrors
}).export module
