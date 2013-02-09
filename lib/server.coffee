express = require 'express'
fs = require 'fs'
path = require 'path'

staticPath = path.join path.dirname(fs.realpathSync(__filename)), '..'

app = express()

# Static dirs
app.use '/js',    express.static(path.join staticPath, 'js')
app.use '/songs', express.static(path.join staticPath, 'songs')
app.use '/spec',  express.static(path.join staticPath, 'spec')

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