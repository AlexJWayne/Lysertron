(function() {
  var echonest, echonest_api, fermata, querystring, rate_limit, _;

  _ = require('underscore');

  fermata = require('fermata');

  querystring = require('querystring');

  echonest_api = require('./echonest_api');

  rate_limit = require('./rate_limit');

  module.exports = echonest = {};

  echonest.Echonest = (function() {

    function Echonest(options) {
      var api, endpoint, httpmethod, method, type, _base, _ref,
        _this = this;
      if (options == null) options = {};
      _.defaults(options, {
        api_key: 'QQKP1N3XKJO7YTSRS',
        api_version: 'v4',
        host: 'http://developer.echonest.com',
        rate_limit: null
      });
      _.extend(this, options);
      if (options.rate_limit) {
        this.rateLimiter = new rate_limit.RateLimiter(options.rate_limit);
      }
      this.jsonclient = fermata.json(this.host)['api'][this.api_version]({
        api_key: this.api_key
      });
      api = echonest_api[this.api_version];
      for (endpoint in api) {
        httpmethod = api[endpoint];
        _ref = endpoint.split('/'), type = _ref[0], method = _ref[1];
        if (this[type] == null) this[type] = {};
        if ((_base = this[type])[method] == null) {
          _base[method] = (function(endpoint, httpmethod) {
            return function(query, callback) {
              if (!options.rate_limit) {
                return _this.request(endpoint, query, callback, httpmethod);
              } else {
                return _this.rateLimiter.addTask(function() {
                  return _this.request(endpoint, query, callback, httpmethod);
                });
              }
            };
          })(endpoint, httpmethod);
        }
      }
    }

    Echonest.prototype.defaultCallback = function(err, data) {
      console.log('err: ', err);
      return console.log('data: ', data);
    };

    Echonest.prototype.request = function(endpoint, query, callback, method) {
      var client, wrapper,
        _this = this;
      if (method == null) method = 'get';
      client = this.jsonclient([endpoint]);
      if (method === 'get') client = client(query);
      wrapper = function(err, result) {
        if (callback == null) callback = _this.defaultCallback;
        if ((result != null ? result.response : void 0) != null) {
          result = result.response;
        }
        if (err && result) err = new Error(err + ': ' + JSON.stringify(result));
        return callback(err, result);
      };
      switch (method) {
        case 'get':
          return client.get(wrapper);
        case 'post':
          return client.post({
            'Content-Type': "multipart/form-data"
          }, query, wrapper);
      }
    };

    return Echonest;

  })();

}).call(this);
