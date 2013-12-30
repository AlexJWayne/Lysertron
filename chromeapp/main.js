chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('public/index.html', {
    bounds: {
      width:  640,
      height: 480
    }
  });
});