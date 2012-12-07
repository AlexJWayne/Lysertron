fs = require 'fs'
request = require 'request'
spawn = require('child_process').spawn

app = require './server/init'
manifest = require './server/manifest'
echoCompiler = require './server/echo'


write = (path, content) ->
  console.log "writing #{path}"
  fs.unlinkSync path if fs.existsSync path
  fs.writeFileSync path, content

spawn('coffee', ['-c', 'js', 'spec']).on 'exit', (code) ->
  
  app.listen 3002
  request "http://localhost:3002/", (err, res, body) ->
    write './index.html', body

    manifest.findEchoes (err, echoes) ->
      for echo in echoes
        [echoType, name] = echo.split '/'
        write "./echoes/#{echoType}/#{name}.js", echoCompiler.compile(echoType, name)

      process.exit()