Lysertron.reloadChromeAppOnUpdate = ->
  version = null

  checkVersion = ->
    $.get 'version', (newVersion) ->
      newVersion = parseInt newVersion, 10

      if version? && version < newVersion
        chrome.runtime.reload()
      else
        version = newVersion

  setInterval checkVersion, 500
