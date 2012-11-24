assert   = require 'assert'
vows     = require 'vows'
_ = require 'underscore'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

vows.describe('error tests').addBatch({
  'when using echonest with a bad api key':
    topic: new echonest.Echonest({api_key: "don't let me in with this api key"})
    "to search for a song":
      topic: (nest) ->
        nest.song.search {}, @callback
        undefined
      'we see a 400': (err, data) ->
        # this comes from fermata
        assert.include err.message, '400'
      'we see an error about a bad api_key': (err, data) ->
        assert.include data.status.message, 'api_key'
      'we see echonest status code 1': (err, data) ->
        assert.equal data.status.code, 1
  'when using echonest':
    topic: new echonest.Echonest()
    "to search for artist familiarity with no parameters":
      topic: (nest) ->
        nest.artist.familiarity {}, @callback # no parameters
        undefined
      'we see a 400': (err, data) ->
        assert.equal err.message, 'Bad status code from server: 400'
      'we see an error about a missing parameter': (err, data) ->
        assert.include data.status.message, 'Missing Parameter'
      'we see echonest status code 4': (err, data) ->
        assert.equal data.status.code, 4
  'when using echonest':
    topic: new echonest.Echonest({api_version: 'bogusVersion'})
    "with a non-existent api endpoint":
      topic: (nest) ->
        # fake endpoint, but specified in echonest_api.coffee
        # under bogusVersion
        nest.fake.endpoint {}, @callback # no parameters
        undefined
      'we see a 502': (err, data) ->
        assert.include err.message, '502'
        # this is from nginx, looks different
        assert.equal data.status, 502
}).export module
