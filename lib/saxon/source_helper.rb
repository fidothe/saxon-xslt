java_import javax.xml.transform.stream.StreamSource

module Saxon
  class SourceHelper
    def self.to_stream_source(path_io_or_string)
      system_id = to_system_id(path_io_or_string)
      StreamSource.new(to_inputstream(path_io_or_string), system_id)
    end

    def self.to_system_id(path_io_or_string)
      if path_io_or_string.respond_to?(:base_uri)
        return path_io_or_string.base_uri.to_s
      end
      return path_io_or_string.path if path_io_or_string.respond_to?(:path)
    end

    def self.to_inputstream(path_io_or_string)
      return path_io_or_string.to_inputstream if path_io_or_string.respond_to?(:read)
      return java.io.StringReader.new(path_io_or_string)
    end
  end
end
