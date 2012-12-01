express = require 'express'
app = express()

# Static dirs
app.use '/js',    express.static('js')
app.use '/songs', express.static('songs')

# Views
app.set 'views', '.'

# Find and register route handlers
routes = [
  'index_html'
  'coffee'
  'echo'
]

for route in routes
  require("./#{route}").register app

module.exports = app