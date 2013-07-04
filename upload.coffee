fs = require 'fs'
request = require 'request'

authKeys = JSON.parse fs.readFileSync('auth.json')
Echonest = new require('echonest').Echonest
echo = new Echonest api_key: authKeys.echonest

[_, _, path, name] = process.argv

console.log "Uploading: #{path}"
console.log "Saving as: #{name}"
console.log "Standby..."

filetype = path.match(/\.(\w+?)$/)[1]

echo.track.upload filetype: filetype, track: fs.readFileSync(path), (error, response) ->
  if error
    console.log error, response
  else
    fs.createReadStream(path).pipe fs.createWriteStream("songs/#{name}.#{filetype}")

    console.log 'response:', response

    setInterval ->
      echo.track.profile id: response.track.id, bucket: 'audio_summary', (error, response) ->
        if error
          console.log error, response
          process.exit()
        else
          console.log 'response:', response

          if response.track.status is 'complete'
            request response.track.audio_summary.analysis_url, (err, res, body) ->
              body = JSON.stringify(JSON.parse(body), null, 2)
              fs.writeFileSync "songs/#{name}.json", body
              console.log 'Done!'
              process.exit()

    , 1000