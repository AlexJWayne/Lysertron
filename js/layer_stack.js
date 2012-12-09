// Generated by CoffeeScript 1.3.3
(function() {
  var __slice = [].slice;

  Echotron.LayerStack = (function() {

    function LayerStack(scene, layers, echoType) {
      this.scene = scene;
      this.layers = layers != null ? layers : [];
      this.echoType = echoType;
    }

    LayerStack.prototype.echoTypes = ['background', 'midground', 'foreground'];

    LayerStack.prototype.beat = function(data) {
      var layer, _i, _len, _ref;
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.active) {
          layer.beat(data);
        }
      }
    };

    LayerStack.prototype.bar = function(data) {
      var layer, _i, _len, _ref;
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.active) {
          layer.bar(data);
        }
      }
    };

    LayerStack.prototype.segment = function(data) {
      var layer, _i, _len, _ref;
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.active) {
          layer.segment(data);
        }
      }
    };

    LayerStack.prototype.tatum = function(data) {
      var layer, _i, _len, _ref;
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.active) {
          layer.tatum(data);
        }
      }
    };

    LayerStack.prototype.update = function(elapsed) {
      var layer, livingLayers, _i, _j, _len, _len1, _ref, _ref1, _results;
      livingLayers = [];
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.expired()) {
          this.scene.remove(layer);
        } else {
          livingLayers.push(layer);
        }
      }
      this.layers = livingLayers;
      _ref1 = this.layers;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        layer = _ref1[_j];
        _results.push(layer.update(elapsed));
      }
      return _results;
    };

    LayerStack.prototype.transition = function() {
      var klass, layer, _i, _len, _ref, _ref1;
      if (!this.echoType) {
        return;
      }
      _ref = this.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        layer.kill();
      }
      klass = Echotron.Echoes[this.echoType].random();
      layer = new klass;
      this.push(layer);
      if ((_ref1 = this.scene) != null) {
        _ref1.add(layer);
      }
      return console.log(this.layers);
    };

    LayerStack.prototype.push = function() {
      var layer, layers, _i, _len, _results;
      layers = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = layers.length; _i < _len; _i++) {
        layer = layers[_i];
        if (!(layer instanceof Echotron.Echo)) {
          throw new Error("LayerStack::push() object is not a Echotron.Echo");
        }
        _results.push(this.layers.push(layer));
      }
      return _results;
    };

    LayerStack.prototype.isEmpty = function() {
      return this.layers.length === 0;
    };

    return LayerStack;

  })();

}).call(this);
