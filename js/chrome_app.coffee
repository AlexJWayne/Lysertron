if chrome?.app?.window

  # Reload the chrome extension
  Lysertron.reloadChromeAppOnUpdate()

  # Listen for drag and dropped files.
  $ -> Lysertron.SongUpload.bindEvents()