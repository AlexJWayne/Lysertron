if chrome.app.window

  song =
    blob: null
    analysis: null

  # Get echonest api key
  echonestHost = "http://developer.echonest.com/api/v4"
  auth = null
  $.getJSON 'auth.json', (json) -> auth = json

  # Returns tru if this event is a valid file dragondrop event.
  isValid = (e) ->
    e = e.originalEvent if e.originalEvent
    dataTransfer = e.dataTransfer || e

    dataTransfer?.types? &&
      ('Files' in dataTransfer.types || 'text/uri-list' in dataTransfer.types)
  
  # Retry until we have the analaysis data available.
  checkForData = (id) ->
    $.ajax
      url: "#{echonestHost}/track/profile"
      type: 'GET'
      dataType: 'json'
      data:
        api_key: auth.echonest
        id: id
        bucket: 'audio_summary'

      success: (res) ->
        # Got it!
        if res.response.track.status is 'complete'
          jsonUrl = res.response.track.audio_summary.analysis_url
          console.log 'SUCCESS', jsonUrl

          $.getJSON jsonUrl, (json) ->
            song.analysis = json
            stage.initSong song
            stage.start()

        # Retry in 5 seconds
        else
          setTimeout ->
            checkForData id
          , 5000

  $window = $(window)

  # File drags over the window.
  $window.on 'dragover', (e) ->
    e.stopPropagation()
    e.preventDefault()

    # if isValid e
    #   console.log 'omg!!'
    # else
    #   console.log 'boooo'

  # File drops on the window.
  $window.on 'drop', (e) ->
    e.preventDefault()
    e.stopPropagation()

    if isValid e
      if 'Files' in e.originalEvent.dataTransfer.types
        file = e.originalEvent.dataTransfer.files[0]
        song.blob = file

        formData = new FormData()
        formData.append 'api_key',  auth.echonest
        formData.append 'filetype', file.name.match(/\.(\w+?)$/)[1]
        formData.append 'track',    file

        console.log "Uploading: #{file.name}"
        $.ajax
          url: "#{echonestHost}/track/upload"
          type: 'POST'
          data: formData
          dataType: 'json'
          processData: false
          contentType: false
          success: (res) -> checkForData res.response.track.id


        
      else # uris
        uri = e.originalEvent.dataTransfer.getData "text/uri-list"
        console.log "uri: #{uri}"
    
    # dragLeave()