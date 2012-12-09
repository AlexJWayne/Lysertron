// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Echotron.EchoStack = (function(_super) {

    __extends(EchoStack, _super);

    function EchoStack() {
      EchoStack.__super__.constructor.apply(this, arguments);
      this.stack = new Echotron.LayerStack(this);
    }

    EchoStack.prototype.push = function() {
      var echo, echoes, _i, _len;
      echoes = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (_i = 0, _len = echoes.length; _i < _len; _i++) {
        echo = echoes[_i];
        this.add(echo);
        this.stack.push(echo);
      }
    };

    EchoStack.prototype.beat = function(beat) {
      return this.stack.beat(beat);
    };

    EchoStack.prototype.bar = function(bar) {
      return this.stack.bar(bar);
    };

    EchoStack.prototype.segment = function(segment) {
      return this.stack.segment(segment);
    };

    EchoStack.prototype.tatum = function(tatum) {
      return this.stack.tatum(tatum);
    };

    EchoStack.prototype.update = function(elapsed) {
      return this.stack.update(elapsed);
    };

    EchoStack.prototype.kill = function() {
      var layer, _i, _len, _ref;
      EchoStack.__super__.kill.apply(this, arguments);
      _ref = this.stack.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        layer.kill();
      }
    };

    EchoStack.prototype.alive = function() {
      return !this.stack.isEmpty();
    };

    return EchoStack;

  })(Echotron.Echo);

}).call(this);
