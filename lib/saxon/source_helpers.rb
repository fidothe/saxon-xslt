module Saxon
  module SourceHelpers
    private

    def to_stream_source(path_io_or_string)
      StreamSource.new(to_inputstream(path_io_or_string))
    end

    def to_inputstream(path_io_or_string)
      return path_io_or_string.to_inputstream if path_io_or_string.respond_to?(:read)
      return java.io.StringReader.new(path_io_or_string)
    end
  end
end
