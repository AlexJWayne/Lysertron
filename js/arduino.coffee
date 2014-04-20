Lysertron.Arduino =
  exists: no
  connection: {}

  flags:
    segment:  1 # 00000001
    tatum:    2 # 00000010
    beat:     4 # 00000100
    bar:      8 # 00001000
    section: 16 # 00010000

  # Find and connect to an Arduino over USB serial.
  connect: ->
    @getArduinoSerialPath (serialPath) =>
      @connection.serialPath = serialPath
      @exists = yes

      if @connection.serialPath
        console.log "Ardunio Found", @connection.serialPath

        chrome.serial.connect @connection.serialPath, {}, (openInfo) =>
          @connection.info = openInfo
          console.log 'Ardunio connected!', @connection.info

          chrome.serial.onReceive.addListener (info) ->
            uint8View = new Uint8Array(info.data)
            result = ''
            for i in [0...uint8View.length]
              result = result + String.fromCharCode(uint8View[i])
            console.log 'Serial Data Received', result

  # Callback with the path of the serial port with the Arduino.
  getArduinoSerialPath: (cb) ->
    chrome.serial.getDevices (devices) =>
      for device in devices
        if device.path.indexOf("/dev/tty.usbmodem") > -1
          cb device.path

  sendByte: (byte) ->
    buffer = new ArrayBuffer(1)
    intBufferView = new Uint8Array(buffer)
    intBufferView[0] = byte
    chrome.serial.send @connection.info.connectionId, buffer, ->

  sendFloats: (floats) ->
    buffer = new ArrayBuffer(floats.length * 4)
    floatBufferView = new Float32Array(buffer)

    for i in [0...floats.length]
      floatBufferView[i] = floats[i]

    chrome.serial.send @connection.info.connectionId, buffer, ->

  dispatchMusicEvent: (data) ->
    byte = 0

    byte = byte | @flags.segment if data.segment
    byte = byte | @flags.tatum   if data.tatum
    byte = byte | @flags.beat    if data.beat
    byte = byte | @flags.bar     if data.bar
    byte = byte | @flags.section if data.section

    durations = []
    durations.push(if data.beat then data.beat.duration else -1)
    durations.push(if data.bar  then data.bar.duration  else -1)

    # console.log 'bitmasked serial byte', byte.toString(2), byte
    @sendByte(byte)
    # @sendFloats(durations)

# Find the arduino!
Lysertron.Arduino.connect()