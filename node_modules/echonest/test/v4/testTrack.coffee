fs = require 'fs'
assert   = require 'assert'
async   = require 'async'
vows     = require 'vows'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

koenjiSong =
  filename:
    'test/data/koenjihyakkei-mederro-passquirr-sample-supercompressed.mp3'
  md5: '03ba8a2e60426497549218321d64829e'
  artistIncludes: "Koenji"
  titleIncludes: "Mederro"

matchesKoenji = (data) ->
  assert.include data.track.artist, koenjiSong.artistIncludes
  assert.include data.track.title, koenjiSong.titleIncludes

vows.describe('track methods').addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to get results from a previously uploaded track with analyze":
      topic: (nest) ->
        nest.track.analyze {
          md5: koenjiSong.md5
        }, @callback
        undefined # async topics must return undefined
      'it is correctly identified': (err, data) ->
        matchesKoenji data
      'we see no errors': checkErrors
    "to get profile from a previously uploaded track with profile":
      topic: (nest) ->
        nest.track.profile {
          md5: koenjiSong.md5
        }, @callback
        undefined
      'it is correctly identified': (err, data) ->
        matchesKoenji data
      'we see no errors': checkErrors
    "to post a koenjihyakkei tune to /track/upload":
      topic: (nest) ->
        filebuffer = fs.readFileSync(koenjiSong.filename)
        nest.track.upload {
          track: {data: filebuffer}, filetype: 'mp3'
        }, @callback
        undefined
      'it is correctly identified': (err, data) ->
        matchesKoenji data
      'we see no errors': checkErrors
}).export module
