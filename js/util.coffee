# get a random element form an array
Array::random = ->
  this[Math.floor Math.random() * @length]


# Temporary vector for use in vector math
THREE.Vector3.temp = (x, y, z) ->
  v = THREE.Vector3._temp ||= new THREE.Vector3
  
  if x? && x instanceof THREE.Vector3
    v.copy x
  else if x? && y? && z?
    v.set x, y, z
  else if x?
    v.set x, x, x
  
  v


  