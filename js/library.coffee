window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem
fs = null

do ->
  oneGig = Math.pow 2, 30 # 1GB
  requestFileSystem window.PERSISTENT, oneGig,
    (_fs) -> # on fs init
      fs = _fs
      console.log fs

    (e) -> # on fs error
      console.log e

Lysertron.Library =

  # Load the song data from local storage.
  load: (cb) ->

    # If already loaded, callback immediately.
    if @songObjs
      cb? this

    # Not yet loaded, load data then callback.
    else
      chrome.storage.local.get 'library', (items) =>
        @songObjs = items.library || []
        # @songObjs = []

        timeout = 0
        for songObj in @songObjs
          do (songObj) =>
            fs.root.getFile songObj.md5, {}, (fileEntry) =>
              console.log 'getFile', songObj.md5
              fileEntry.file (file) =>
                console.log 'fileEntry', songObj.md5
                songObj.blob = file
                cb this if cb && @doAllSongsHaveFiles()

  doAllSongsHaveFiles: ->
    for songObj in @songObjs
      return no unless songObj.blob

    return yes

  # Save song data to local storage.
  save: (cb) ->
    songObjsWithoutBlob =
      for songObj in @songObjs

        # Save each song file.
        fs.root.getFile songObj.md5, create: true, (fileEntry) ->
          fileEntry.createWriter (fileWriter) ->
            fileWriter.onwriteend = (e) ->
              console.log 'Song file saved!', fileEntry, e

            fileWriter.onerror    = (e) ->
              console.log 'fileWriter.onerror', e

            fileWriter.write songObj.blob
          , (e) -> console.log 'fileEntry.createWriter error', e
        , (e) -> console.log 'fs.root.getFile error', e

        # Collect objects of just meta data, not binary blob data.
        {
          title:    songObj.title
          artist:   songObj.artist
          md5:      songObj.md5
          analysis: songObj.analysis
        }

    # Save the song objects in local storage.
    chrome.storage.local.set library: songObjsWithoutBlob, =>
      cb? this


  # Ask if the song object is currently saved in the library.
  get: (songObj) ->
    for libSongObj in @songObjs
      if libSongObj.md5 is songObj.md5
        return libSongObj

    return no

  # Add a song to the library for permanent storage.
  add: (songObj) ->
    if !songObj.blob || !songObj.md5 || !songObj.analysis
      throw new Error('song object to add requires a blob, md5 and analysis.')

    unless @get songObj
      @songObjs.push songObj
      @songObjs = @songObjs.sort (a, b) ->
        aString = "#{ a.artist } - #{ a.title }"
        bString = "#{ b.artist } - #{ b.title }"
        
        if aString > bString
          1
        else if aString < bString
          -1
        else
          0

      @save()
      stage.createSongSelector songObj
