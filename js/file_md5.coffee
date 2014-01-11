# Accepts a file and callback with an MD5 checksum of that file contents.
# This checksum is used to uniquely identify a specific song file so that
# it doesn't need to be re-uploaded and re-analyzed.
class Lysertron.FileMD5
  chunkSize: 1048576 # read in chunks of 1MB

  constructor: (@file, options = {}) ->
    @started = performance.now()
    @chunks = Math.ceil @file.size / @chunkSize
    @currentChunk = 0
    
    @onComplete = options.complete
    @onProgress = options.progress

    @spark = new SparkMD5.ArrayBuffer()
    @readNextChunk()
  
  # Read in a chunk, and append it to the hasher.
  onReaderLoad: (e) =>
    console.log "MD5: Read Chunk #{ @currentChunk + 1 }/#{ @chunks }"
    
    @onProgress? @currentChunk / @chunks

    @spark.append e.target.result # append array buffer
    @currentChunk++

    # More chunks to read.
    if @currentChunk < @chunks
      @readNextChunk()
    
    # Done reading chunks!
    else
      md5 = @spark.end()
      console.info "MD5 Computed Hash:", md5, "#{Math.round performance.now() - @started}ms"
      @onComplete? md5 # Callback with result
      
  onReaderError: (e) =>
    console.warn "Unable to compute hash!", e
  
  # Setup the next chunk to load into the hasher.
  readNextChunk: =>
    fileReader = new FileReader()
    fileReader.onload  = @onReaderLoad
    fileReader.onerror = @onReaderError

    start = @currentChunk * @chunkSize
    end =
      if (start + @chunkSize) >= @file.size
        @file.size
      else
        start + @chunkSize

    fileReader.readAsArrayBuffer @file.slice(start, end)
