Lysertron.Arduino =
  exists: no
  connection: {}

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

          # chrome.serial.onReceive.addListener (info) ->
          #   uint8View = new Uint8Array(info.data)
          #   value = String.fromCharCode(uint8View[0])
          #   console.log 'Serial Data Received', value

  # Callback with the path of the serial port with the Arduino.
  getArduinoSerialPath: (cb) ->
    chrome.serial.getDevices (devices) =>
      for device in devices
        if device.path.indexOf("/dev/tty.usbmodem") > -1
          cb device.path

  sendInt: (value) ->
    buffer = new ArrayBuffer(1)
    uint8View = new Uint8Array(buffer)
    uint8View[0] = value
    chrome.serial.send @connection.info.connectionId, buffer, ->


  dispatchMusicEvent: (data) ->
    @sendInt 1 if data.segment
    @sendInt 2 if data.tatum
    @sendInt 3 if data.beat
    @sendInt 4 if data.bar
    @sendInt 5 if data.section

# Find the arduino!
Lysertron.Arduino.connect()