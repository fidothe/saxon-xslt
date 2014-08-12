java_import javax.xml.transform.stream.StreamSource

module Saxon
  # Helper methods for converting Ruby File, IO, Path, or String objects into a
  # Javax StreamSource object for Saxon's Document parser or XSLT compiler to
  # consume
  class SourceHelper
    # Creates a StreamSource from its input
    # @param [File, IO, String] path_io_or_string A File, or IO
    #   object representing the input XML file or data, or a String containing
    #   the XML
    # @param [Hash] opts
    # @option opts [String] :system_id The System ID of the source - an
    #   absolute URI or relative path pointing to the location of the source
    # @return [java.xml.transform.stream.StreamSource] a StreamSource for
    #   consuming the input
    def self.to_stream_source(path_io_or_string, opts = {})
      system_id = opts.fetch(:system_id) { to_system_id(path_io_or_string) }
      StreamSource.new(to_inputstream(path_io_or_string), system_id)
    end

    # Given a File, or IO object which will return either #path or
    # #base_uri, return the #base_uri, if present, or the #path, if present, or
    # nil
    # @param [File, IO, String] path_io_or_string A Path, File, or IO
    #   object representing the input XML file or data, or a String containing
    #   the XML
    def self.to_system_id(path_io_or_string)
      if path_io_or_string.respond_to?(:base_uri)
        return path_io_or_string.base_uri.to_s
      end
      return path_io_or_string.path if path_io_or_string.respond_to?(:path)
    end

    # Given a File, IO, or String return a Java InputStream or StringReader
    # @param [File, IO, String] path_io_or_string input to be converted to an
    #   input stream
    # @return [java.io.InputStream, java.io.StringReader] the wrapped input
    def self.to_inputstream(path_io_or_string)
      return path_io_or_string.to_inputstream if path_io_or_string.respond_to?(:read)
      return java.io.StringReader.new(path_io_or_string)
    end
  end
end
