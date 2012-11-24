assert   = require 'assert'
vows     = require 'vows'
async = require 'async'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

# FIXME: some callbacks across all tests take data arg
# should be response

vows.describe('artist methods').addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to search for spin doctors biographies":
      topic: (nest) ->
        nest.artist.biographies {
          name: 'spin doctors'
        }, @callback
        undefined
      'the first result mentions New York': (err, data) ->
        bioText = data.biographies[0].text
        assert.include bioText, 'New York'
      'we see no errors': checkErrors
    "to search for blog posts about behold the arctopus":
      topic: (nest) ->
        nest.artist.blogs {
          name: 'behold... the arctopus'
        }, @callback
        undefined
      'the first result has a url': (err, data) ->
        firstURL = data.blogs[0].url
        assert.include firstURL, 'http'
      'we see no errors': checkErrors
    "to search for familiarity of behold the arctopus and paula abdul":
      topic: (nest) ->
        async.parallel({
          behold: (callback) -> nest.artist.familiarity {
            name: 'behold... the arctopus'
          }, callback
          paula: (callback) -> nest.artist.familiarity {
            name: 'paula abdul'
          }, callback
        }, @callback)
        undefined
      'behold is less familiar than paula': (err, results) ->
        beholdFamiliarity = results.behold.artist.familiarity
        paulaFamiliarity = results.paula.artist.familiarity
        assert beholdFamiliarity < paulaFamiliarity
      'we see no errors': (err, results) ->
        checkErrors err, results['paula']
        checkErrors err, results['behold']
    "to search for the hotttness of justin timberlake":
      topic: (nest) ->
        nest.artist.hotttnesss {
          name: 'justin timberlake'
        }, @callback
        undefined
      'his hotttnesss exceeds 0.01': (err, response) ->
        assert.ok response.artist.hotttnesss > 0.01
      'we see no errors': checkErrors
    "to list mood terms":
      topic: (nest) ->
        nest.artist.list_terms {
          type: 'mood'
        }, @callback
        undefined
      'happy is among them': (err, response) ->
        assert.include((term.name for term in response.terms), 'happy')
      'we see no errors': checkErrors
    "to search for news about radiohead":
      topic: (nest) ->
        nest.artist.news {
          name: 'radiohead'
        }, @callback
        undefined
      'we get some': (err, response) ->
        assert.ok response.total > 0
      'we see no errors': checkErrors
    "to get a profile for behold... the arctopus":
      topic: (nest) ->
        nest.artist.profile {
          name: 'behold... the arctopus'
        }, @callback
        undefined
      'we get something': (err, response) ->
        assert.include response.artist.name, 'Arctopus'
      'we see no errors': checkErrors
    "to get reviews for venetian snares":
      topic: (nest) ->
        nest.artist.reviews {
          name: 'venetian snares'
        }, @callback
        undefined
      'we get some': (err, response) ->
        assert.ok response.total > 0
      'we see no errors': checkErrors
    "to search for the hotttessst artist":
      topic: (nest) ->
        nest.artist.search {
          results: 1
          sort: 'hotttnesss-desc'
        }, @callback
        undefined
      'we get someone': (err, response) ->
        assert.ok response.artists[0].name.length > 0
      'we see no errors': checkErrors
    "to extract names from 'behold... the arctopus pickle beatles
        computer jesus refrigerator'":
      topic: (nest) ->
        nest.artist.extract {
          text: 'behold... the arctopus pickle beatles
            computer jesus refrigerator'
        }, @callback
        undefined
      'we get the beatles': (err, response) ->
        names = (artist.name for artist in response.artists)
        assert.include names, 'The Beatles'
      'we see no errors': checkErrors
    "to search for songs by Los del Rio":
      topic: (nest) ->
        nest.artist.songs {
          name: 'Los del Rio'
        }, @callback
        undefined
      'we get the macarena': (err, response) ->
        titles = (song.title for song in response.songs)
        assert.include titles, 'Macarena'
      'we see no errors': checkErrors
    "to search for artists similar to converge":
      topic: (nest) ->
        nest.artist.similar {
          name: 'converge'
          results: 30
        }, @callback
        undefined
      'we get Dillinger': (err, response) ->
        names = (artist.name for artist in response.artists)
        assert.include names, 'The Dillinger Escape Plan'
      'we see no errors': checkErrors
    "search for suggestions on the partial name dillinger":
      topic: (nest) ->
        nest.artist.suggest {
          name: 'dillinger'
          results: 30
        }, @callback
        undefined
      'we get the dillinger escape plan': (err, response) ->
        names = (artist.name for artist in response.artists)
        assert.include names, 'The Dillinger Escape Plan'
      'we see no errors': checkErrors
    "to search for terms that describe converge":
      topic: (nest) ->
        nest.artist.terms {
          name: 'converge'
        }, @callback
        undefined
      '"hardcore" is among them': (err, response) ->
        terms = (term.name for term in response.terms)
        assert.include terms, 'hardcore'
      'we see no errors': checkErrors
    "to search for top_hottt":
      topic: (nest) ->
        nest.artist.top_hottt {
        }, @callback
        undefined
      'we get some': (err, response) ->
        names = (artist.name for artist in response.artists)
        assert.ok names.length > 1
      'we see no errors': checkErrors
    "to search for top_terms":
      topic: (nest) ->
        nest.artist.top_terms {
        }, @callback
        undefined
      'we get some': (err, response) ->
        terms = (term.name for term in response.terms)
        assert.ok terms.length > 1
      'we see no errors': checkErrors
    "to search for justin bieber's twitter handle":
      topic: (nest) ->
        nest.artist.twitter {
          name: "justin bieber"
        }, @callback
        undefined
      'we get justinbieber': (err, response) ->
        assert.equal response.artist.twitter, 'justinbieber'
      'we see no errors': checkErrors
    "to search for urls related to justin bieber":
      topic: (nest) ->
        nest.artist.urls {
          name: "justin bieber"
        }, @callback
        undefined
      'we get his wikipedia page': (err, response) ->
        assert.equal response.urls.wikipedia_url,
          'http://en.wikipedia.org/wiki/Justin_Bieber'
      'we see no errors': checkErrors
    "to search for justin bieber video":
      topic: (nest) ->
        nest.artist.video {
          name: "justin bieber"
        }, @callback
        undefined
      'we get more than 100': (err, response) ->
        assert.ok response.total > 100
      'we see no errors': checkErrors
}).export(module)
