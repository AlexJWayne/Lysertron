class Lysertron.SongUpload
  echonestHost: "http://developer.echonest.com/api/v4"
  $.getJSON 'auth.json', (json) => @::echonestKey = json.echonest

  # Start an upload of a given file object.
  constructor: (file) ->
    @progressBar      = null
    @progressBarValue = null
    @song =
      blob:     file
      analysis: null

    @uploadFile()

  # Upload the file to Echonest.
  uploadFile: ->
    # Construct a FormData object for a file upload to EchoNest.
    formData = new FormData()
    formData.append 'api_key',  @echonestKey
    formData.append 'filetype', @song.blob.name.match(/\.(\w+?)$/)[1]
    formData.append 'track',    @song.blob

    # Upload via AJAX.
    console.log "Uploading: #{@song.blob.name}"
    upload = $.ajax
      url: "#{@echonestHost}/track/upload"
      type: 'POST'
      data: formData
      dataType: 'json'
      processData: false
      contentType: false
      xhr: @xhrWithProgress
      success: (res) =>
        @echonestId = res.response.track.id
        @checkForAnalysis()

  # Returns an xh object that is tapped to report progress.
  xhrWithProgress: =>
    xhr = jQuery.ajaxSettings.xhr()
    xhr.upload.addEventListener 'progress', @reportProgress, false
    xhr

  # Create the progress bar view to later manipulate.
  createProgressBar: ->
    @progressBar = $('<div id="progressBar">')
    @progressBarValue = $('<div id="progressBarValue">').appendTo @progressBar
    @progressBar.prependTo $(document.body)

  # Update the progress bar to show current upload status.
  reportProgress: (e) =>
    @createProgressBar() unless @progressBar

    loaded = Math.round e.loaded / 1000
    progress = e.loaded / e.total
    console.log "#{loaded}KB (#{Math.round progress * 100}%)"

    fullWidth = @progressBar.width() - 20
    @progressBarValue.css width: "#{fullWidth * progress}px"

    if progress < 1
      @progressBarValue.text "#{loaded}k"
    else
      @progressBarValue
        .addClass('waiting')
        .text "Analyzing..."

  # Ask echonest if the analysis is done yet.
  checkForAnalysis: ->
    $.ajax
      url: "#{@echonestHost}/track/profile"
      type: 'GET'
      dataType: 'json'
      data:
        api_key: @echonestKey
        id: @echonestId
        bucket: 'audio_summary'

      success: (res) =>
        # Got it! :D
        if res.response.track.status is 'complete'
          jsonUrl = res.response.track.audio_summary.analysis_url
          console.log 'SUCCESS', jsonUrl
          @fetchAnalysis jsonUrl

        # Will never get it :(
        else if res.response.track.status is 'error'
          console.log 'ERROR', res
          @progressBar.remove()
          @progressBar = null

        # Retry in 5 seconds
        else
          console.log 'Analysis status:', res.response.track.status
          setTimeout =>
            @checkForAnalysis()
          , 5000

  # Download the completed analaysis JSON file.
  fetchAnalysis: (jsonUrl) ->
    $.getJSON jsonUrl, (json) =>
      @progressBar.remove()
      @progressBar = null

      @song.analysis = json
      stage.initSong @song
      stage.start()

  # Bind the file drag and drop event to the window.
  @bindEvents = ->
    $(window)
      .on('drop',     @onDragDrop)
      .on('dragover', @onDragOver)

  # File is being dragged over the window.
  @onDragOver = (e) =>
    e.stopPropagation()
    e.preventDefault()

  # File was dropped on the window.
  @onDragDrop = (e) =>
    e.preventDefault()
    e.stopPropagation()

    if @isValidFileDrop e
      if 'Files' in e.originalEvent.dataTransfer.types
        file = e.originalEvent.dataTransfer.files[0]
        new SongUpload file
        
      else # uris
        uri = e.originalEvent.dataTransfer.getData "text/uri-list"
        console.log "uri: #{uri}"

    return false

  # Is the currently dragged thing over the window a file?
  @isValidFileDrop: (e) ->
    e = e.originalEvent if e.originalEvent
    dataTransfer = e.dataTransfer || e

    dataTransfer?.types? &&
      ('Files' in dataTransfer.types || 'text/uri-list' in dataTransfer.types)