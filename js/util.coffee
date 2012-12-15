# Get a random element form an array.
Array::random || Object.defineProperty Array::, 'random',
  value: ->
    this[Math.floor Math.random() * @length]

# Temporary vector for use in vector math.
THREE.Vector3.temp = (x, y, z) ->
  v = THREE.Vector3._temp ||= new THREE.Vector3
  
  if x? && x instanceof THREE.Vector3
    v.copy x
  else if x? && y? && z?
    v.set x, y, z
  else if x?
    v.set x, x, x
  
  v


# degrees to radians
Number::degToRad || Object.defineProperty Number::, 'degToRad',
  get: ->
    this * Math.PI/180

# radians to degrees
Number::radToDeg || Object.defineProperty Number::, 'radToDeg',
  get: ->
    this * 180/Math.PI

# seconds to milliseconds
Number::ms || Object.defineProperty Number::, 'ms',
  get: ->
    this * 1000

# Return the value of a query string parameter.
window.getParam = (name) ->
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]")
  regexS = "[\\?&]" + name + "=([^&#]*)"
  regex = new RegExp regexS
  results = regex.exec window.location.search
  if results
    decodeURIComponent results[1].replace(/\+/g, " ")
  else
    null