chrome.app.runtime.onLaunched.addListener(function() {

  // Before we open the window, look for the bounds of the last window.
  chrome.storage.local.get('lastBounds', function(items) {

    // Get bounds form the last time we were open, if possible.
    var bounds = items.lastBounds || { width: 640, height: 480 }

    // Spawn the window
    chrome.app.window.create(

      // Path to window html file.
      'public/index.html',

      // Options.
      { bounds: bounds },

      // After window is created, listen for the bounds being changes and save them.
      function(win) {
        win.onBoundsChanged.addListener(function() {
          chrome.storage.local.set({lastBounds: win.getBounds()});
        });
      }
    );
  });
});