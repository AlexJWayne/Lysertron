assert   = require 'assert'
vows     = require 'vows'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

vows.describe('multibucket support').addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to search for soul to squeeze with multiple buckets:
        audio_summary, track, id:rdio":
      topic: (nest) ->
        nest.song.search {
          title: 'soul to squeeze'
          bucket: ['tracks', 'audio_summary', 'id:rdio-us-streaming']
          limit: true
        }, @callback
        undefined
      'we get foreign ids and an audio_summary!': (err, data) ->
        rhcp_songs = (song.artist_name for song in data.songs)
        assert.include rhcp_songs, 'Red Hot Chili Peppers'
        first_song = data.songs[0]
        # look at foreign ids and danceability
        assert.isTrue first_song.foreign_ids.length > 0
        assert.isNotNull first_song.audio_summary.danceability
      'we see no errors': checkErrors
}).export module
