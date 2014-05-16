module Saxon
  module SourceHelpers
    java_import 'javax.xml.transform.stream'

    private

    ##
    # Take a String or File and wrap it with Java StreamSource.
    # System ID is set to the file path if input responds to path or can be given
    # a user supplied system ID if a string is given
    #
    # @param[String,IO] io_or_string The IO handle or the String contents
    # @return[javax.xml.transform.stream.StreamSource]
    def to_stream_source(io_or_string, system_id = nil)
      stream_source = StreamSource.new(to_inputstream(path_io_or_string))
      system_id ||= io_or_string.path if path_io_or_string.respond_to?(:path)
      stream_source.setSystemId(system_id)

      stream_source
    end

    def to_inputstream(io_or_string)
      return io_or_string.to_inputstream if io_or_string.respond_to?(:read)
      return java.io.StringReader.new(io_or_string)
    end
  end
end
