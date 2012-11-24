assert   = require 'assert'
vows     = require 'vows'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

vows.describe('song methods').addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to search for soul to squeeze":
      topic: (nest) ->
        nest.song.search {
          title: 'soul to squeeze'
        }, @callback
        undefined
      'we get a rhcp song': (err, data) ->
        rhcp_songs = (song.artist_name for song in data.songs)
        assert.include rhcp_songs, 'Red Hot Chili Peppers'
      'we see no errors': checkErrors
    "to get profile for paula abdul's straight up":
      topic: (nest) ->
        nest.song.profile {
          id: 'SOTIWAP12A8C13BA56'
          bucket: 'artist_familiarity'
        }, @callback
        undefined
      'she is familiar': (err, data) ->
        familiarity = data.songs[0].artist_familiarity
        assert familiarity > 0.5
      'we see no errors': checkErrors
    "to post to identify with a fingerprint":
      topic: (nest) ->
        # fingerprint code taken from
        # http://developer.echonest.com/docs/v4/song.html#identify
        # FIXME: having to encode json myself is a little crappy
        # we wouldn't have to do this if we did a get with a querystring,
        # but these fingerprints are long
        nest.song.identify {
          query:
            JSON.stringify({
              metadata:
                artist: "Michael Jackson"
              code: "eJxVlIuNwzAMQ1fxCDL133-xo1rnGqNAEcWy_ERa2aKeZmW9ustWVYr" +
                "Xrl5bthn_laFkzguNWpklEmoTB74JKYZSPlbJ0sy9fQrsrbEaO9W3bsbaWO" +
                "oK7IhkHFaf_ag2d75oOQSZczbz5CKA7XgTIBIXASvFi0A3W8pMUZ7FZTWTV" +
                "bujCcADlQ_f_WbdRNJ2vDUwSF0EZmFvAku_CVy440fgiIvArWZZWoJ7GWd-" +
                "CVTYC5FCFI8GQdECdROE20UQfLoIUmhLC7IiByF1gzbAs3tsSKctyC76MPJ" +
                "lHRsZ5qhSQhu_CJFcKtW4EMrHSIrpTGLFqsdItj1H9JYHQYN7W2nkC6GDPj" +
                "ZTAzL9dx0fS4M1FoROHh9YhLHWdRchQSd_CLTpOHkQQP3xQsA2-sLOUD7Cz" +
                "xU0GmHVdIxh46Oide0NrNEmjghG44Ax_k2AoDHsiV6WsiD6OFm8y-0Lyt8h" +
                "aDBBzeMlAnTuuGYIB4WA2lEPAWbdeOabgFN6TQMs6ctLA5fHyKMBB0veGrj" +
                "PfP00IAlWNm9n7hEh5PiYYBGKQDP-x4F0CL8HkhoQnRWN997JyEpnHFR7Eh" +
                "LPQMZmgXS68hsHktEVErranvSSR2VwfJhQCnkuwhBUcINNY-xu1pmw3PmBq" +
                "U9-8xu0kiF1ngOa8vwBSSzzNw=="
            })
        }, @callback
        undefined
      'it is correctly identified as Billie Jean': (err, response) ->
        assert.include response.songs[0].title, 'Billie'
      'we see no errors': checkErrors
}).export module
