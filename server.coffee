#!/usr/bin/env coffee

app = require './server/init'

[_, _, port] = process.argv

# Start Server
console.log "Started server on port 3001"
app.listen port || 3001