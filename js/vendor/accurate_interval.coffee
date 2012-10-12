# Accurate Interval, guaranteed not to drift!
# (Though each call can still be a few milliseconds late)
window.accurateInterval = (time, fn) ->

  # This value is the next time the the timer should fire.
  nextAt = new Date().getTime() + time

  # Hold a reference to the timer ID so it can be canceled.
  timeout = null

  # Allow arguments to be passed in in either order.
  if typeof time is 'function'
    [fn, time] = [time, fn]

  # Create a function that wraps our function to run.  This is responsible for
  # scheduling the next call and aborting when canceled.
  wrapper = ->
    nextAt += time
    timeout = setTimeout wrapper, nextAt - new Date().getTime()
    fn()

  # Clear the next call when canceled.
  cancel = -> clearTimeout timeout

  # Schedule the first call.
  timeout = setTimeout wrapper, nextAt - new Date().getTime()

  # Return an object that contains the cancel() function so we can later cancel.
  return { cancel }