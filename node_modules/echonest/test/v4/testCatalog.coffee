assert   = require 'assert'
async   = require 'async'
vows     = require 'vows'
echonest = require '../../lib/echonest'
util = require '../util'

checkErrors = util.checkErrors

catalog_data = [
  "item":
    {
      "item_id": "0CF07A178DBF78F7"
      "song_name" : "Harmonice Mundi II"
      "artist_name" : "Six Organs Of Admittance"
      "play_count" : 400
    }
]

# FIXME: delete is only tested on existing test catalogs
# from last run

vows.describe('catalog methods').addBatch({
  # clear all existing catalogs for this api_key
  # that look like "echonest.js test catalog*"
  'when using echonest':
    topic: new echonest.Echonest
    "to list catalogs":
      topic: (nest) ->
        nest.catalog.list {
        }, @callback
        undefined
      'we see no errors': checkErrors
      'we get a list': (err, response) ->
        assert.ok response.catalogs?
      'we can delete all the test catalogs':
        topic: (response, nest) ->
          catalogDelete = (id, callback) ->
            nest.catalog.delete {
              id: id
            }, callback
          # get ids of just test catalogs
          isTestCatalog = (name) -> /test catalog/.test(name)
          ids = for catalog in response.catalogs when isTestCatalog catalog.name
            catalog.id
          deletes = {}
          for id in ids
            deletes[id] = do (id) -> (callback) ->
              catalogDelete(id, callback)
          async.parallel(deletes, @callback)
        'and we see no errors': (err, results) ->
          for id, result of results
            checkErrors err, result
}).addBatch({
  'when using echonest':
    topic: new echonest.Echonest
    "to create a catalog":
      topic: (nest) ->
        nest.catalog.create {
          name: "echonest.js test catalog"
          type: "song"
        }, @callback
        undefined
      'we see no errors': checkErrors
      'i get an id': (err, response) ->
        assert.ok response.id.length > 0
      'I can update my catalog':
        topic: (response, nest) ->
          nest.catalog.update {
            id: response.id
            data: JSON.stringify catalog_data
          }, @callback
        'and we see no errors': checkErrors
        'and get a ticket': (err, response) ->
          assert.ok response.ticket.length > 0
        'and I can use the ticket to get the catalog update status':
          topic: (response, parentResponse, nest) ->
            nest.catalog.status {
              ticket: response.ticket
            }, @callback
          'and we see no errors': checkErrors
          'and ticket_status is not "error"': (err, response) ->
            assert.notEqual response.ticket_status, "error"
        'and I can get a catalog feed':
          topic: (response, parentResponse, nest) ->
            nest.catalog.feed {
              id: parentResponse.id
            }, @callback
          'and we see no errors': checkErrors
          'and there is a feed (could be empty)': (err, response) ->
            assert.ok response.feed?
      'I can get a profile of my catalog':
        topic: (response, nest) ->
          nest.catalog.profile {
            id: response.id
          }, @callback
        'and we see no errors': checkErrors
        'and it is song catalog': (err, response) ->
          assert.equal response.catalog.type, "song"
      'I can read the catalog':
        topic: (response, nest) ->
          nest.catalog.read {
            id: response.id
          }, @callback
        'and we see no errors': checkErrors
        'and it is song catalog': (err, response) ->
          assert.equal response.catalog.type, "song"
}).export module
