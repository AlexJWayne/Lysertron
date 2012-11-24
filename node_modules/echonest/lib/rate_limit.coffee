_ = require 'underscore'

getNow = -> (new Date).getTime()

module.exports = rate_limit = {}

class rate_limit.RateLimiter
  # rate limiter for async tasks
  constructor: (@minDelta) ->
    @queue = []
    @lastCall = do getNow

  processQueue: (s) =>
    # takes self argument
    # so recursive call has
    # reference to instance
    now = do getNow
    currDelta = now - s.lastCall
    nextAvailable = s.lastCall + s.minDelta
    unless _.isEmpty s.queue
      if currDelta >= s.minDelta
        task = do s.queue.shift
        _.defer task
        s.lastCall = now
        nextAvailable = now + s.minDelta
      unless _.isEmpty s.queue
        waitTime = nextAvailable - now
        _.delay (-> s.processQueue s), waitTime

  addTask: (func) ->
    @queue.push(func)
    unless @queue.length > 1
      @processQueue @
