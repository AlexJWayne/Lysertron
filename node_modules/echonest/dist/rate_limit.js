(function() {
  var getNow, rate_limit, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('underscore');

  getNow = function() {
    return (new Date).getTime();
  };

  module.exports = rate_limit = {};

  rate_limit.RateLimiter = (function() {

    function RateLimiter(minDelta) {
      this.minDelta = minDelta;
      this.processQueue = __bind(this.processQueue, this);
      this.queue = [];
      this.lastCall = getNow();
    }

    RateLimiter.prototype.processQueue = function(s) {
      var currDelta, nextAvailable, now, task, waitTime;
      now = getNow();
      currDelta = now - s.lastCall;
      nextAvailable = s.lastCall + s.minDelta;
      if (!_.isEmpty(s.queue)) {
        if (currDelta >= s.minDelta) {
          task = s.queue.shift();
          _.defer(task);
          s.lastCall = now;
          nextAvailable = now + s.minDelta;
        }
        if (!_.isEmpty(s.queue)) {
          waitTime = nextAvailable - now;
          return _.delay((function() {
            return s.processQueue(s);
          }), waitTime);
        }
      }
    };

    RateLimiter.prototype.addTask = function(func) {
      this.queue.push(func);
      if (!(this.queue.length > 1)) return this.processQueue(this);
    };

    return RateLimiter;

  })();

}).call(this);
