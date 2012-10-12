# Special thanks to:
#
#     http://gizma.com/easing/
#

Tween =
  # LINEAR
  linear: (t, b, c, d) ->
    c*t/d + b
  
  # QUADRATIC
  easeInQuad: (t, b, c, d) ->
    t /= d
    c*t*t + b
  
  easeOutQuad: (t, b, c, d) ->
    t /= d
    -c * t*(t-2) + b
  
  easeInOutQuad: (t, b, c, d) ->
    t /= d/2
    if t < 1
      c/2*t*t + b
    else
      t--
      -c/2 * (t*(t-2) - 1) + b
  
  # CUBIC
  easeInCubic: (t, b, c, d) ->
    t /= d
    c*t*t*t + b
  
  easeOutCubic: (t, b, c, d) ->
    t /= d
    t--
    c*(t*t*t + 1) + b
  
  easeInOutCubic: (t, b, c, d) ->
    t /= d/2
    if t < 1
      c/2*t*t*t + b
    else
      t -= 2
      c/2*(t*t*t + 2) + b
  
  # QUARTIC
  easeInQuart: (t, b, c, d) ->
    t /= d
    c*t*t*t*t + b
  
  easeOutQuart: (t, b, c, d) ->
    t /= d
    t--
    -c * (t*t*t*t - 1) + b
  
  easeInOutQuart: (t, b, c, d) ->
    t /= d/2
    if t < 1
      c/2*t*t*t*t + b
    else
      t -= 2
      -c/2 * (t*t*t*t - 2) + b
  
  # QUINTIC
  easeInQuint: (t, b, c, d) ->
    t /= d
    c*t*t*t*t*t + b
  
  easeOutQuint: (t, b, c, d) ->
    t /= d
    t--
    c*(t*t*t*t*t + 1) + b

  easeInOutQuint: (t, b, c, d) ->
    t /= d/2
    if t < 1
      c/2*t*t*t*t*t + b
    else
      t -= 2;
      c/2*(t*t*t*t*t + 2) + b
  
  # SINE
  easeInSine: (t, b, c, d) ->
    -c * Math.cos(t/d * (Math.PI/2)) + c + b
  
  easeOutSine: (t, b, c, d) ->
    c * Math.sin(t/d * (Math.PI/2)) + b
  
  easeInOutSine: (t, b, c, d) ->
    -c/2 * (Math.cos(Math.PI*t/d) - 1) + b
  
  # EXPONENTIAL
  easeInExpo: (t, b, c, d) ->
    c * Math.pow( 2, 10 * (t/d - 1) ) + b
  
  easeOutExpo: (t, b, c, d) ->
    c * ( -Math.pow( 2, -10 * t/d ) + 1 ) + b
  
  easeInOutExpo: (t, b, c, d) ->
    t /= d/2
    if t < 1
      c/2 * Math.pow( 2, 10 * (t - 1) ) + b
    else
      t--
      c/2 * ( -Math.pow( 2, -10 * t) + 2 ) + b
  
  # CIRCULAR
  easeInCirc: (t, b, c, d) ->
    t /= d
    -c * (Math.sqrt(1 - t*t) - 1) + b
  
  easeOutCirc: (t, b, c, d) ->
    t /= d
    t--
    c * Math.sqrt(1 - t*t) + b
  
  easeInOutCirc: (t, b, c, d) ->
    t /= d/2
    if t < 1
      -c/2 * (Math.sqrt(1 - t*t) - 1) + b
    else
      t -= 2
      c/2 * (Math.sqrt(1 - t*t) + 1) + b

# Aliases
Tween.low   = Tween.easeInSine
Tween.high  = Tween.easeOutSine
Tween.ease  = Tween.easeInOutSine
              
Tween.low2  = Tween.easeInQuad
Tween.high2 = Tween.easeOutQuad
Tween.ease2 = Tween.easeInOutQuad
              
Tween.low3  = Tween.easeInCubic
Tween.high3 = Tween.easeOutCubic
Tween.ease3 = Tween.easeInOutCubic
              
Tween.low4  = Tween.easeInQuart
Tween.high4 = Tween.easeOutQuart
Tween.ease4 = Tween.easeInOutQuart
              
Tween.low5  = Tween.easeInQuint
Tween.high5 = Tween.easeOutQuint
Tween.ease5 = Tween.easeInOutQuint

# Setup Curve
Curve = {}
for own name, fn of Tween
  do (name, fn) ->
    Curve[name] = (n) ->
      fn n, 0, 1, 1

scope = window ? exports
scope.Tween = Tween
scope.Curve = Curve