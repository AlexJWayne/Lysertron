assert   = require 'assert'
vows     = require 'vows'

module.exports = util = {}

util.checkErrors = (err, data) ->
  assert.equal data.status.message, 'Success'
  assert.equal data.status.code, 0
  err? and throw err
