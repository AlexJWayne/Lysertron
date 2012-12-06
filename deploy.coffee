request = require 'request'
app = require './server/init'
app.listen 3002

request "http://localhost:3002/", (err, res, body) ->
  console.log err, res, body
  process.exit()