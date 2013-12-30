if chrome.app.window
  isValid = (dataTransfer) ->
    dataTransfer?.types? && (
      dataTransfer.types.indexOf('Files') >= 0 ||
      dataTransfer.types.indexOf('text/uri-list') >=0
    )
  
  $window = $(window)

  # File drags over the window.
  $window.on 'dragover', (e) ->
    e.stopPropagation()
    e.preventDefault()

    # if isValid e.dataTransfer
    #   console.log 'omg!!'
    # else
    #   console.log 'boooo'

  # File drops on the window.
  $window.on 'drop', (e) ->
    e.preventDefault()
    e.stopPropagation()

    if isValid e.dataTransfer
      if 'Files' in e.dataTransfer.types
        for file in e.dataTransfer.files
          text = "#{file.name}, #{file.size} bytes"
          reader = new FileReader
          reader.onload = (e) -> console.log e.target.result
          reader.readAsText file
        
      else # uris
        uri = e.dataTransfer.getData "text/uri-list"
        console.log "uri: #{uri}"
    
    # dragLeave()