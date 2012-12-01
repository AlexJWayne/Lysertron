#!/usr/bin/env coffee

app = require './server/init'

# Start Server
console.log "Started server on port 3001"
app.listen 3001