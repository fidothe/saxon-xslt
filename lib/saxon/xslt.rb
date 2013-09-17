require 'saxon/xslt/version'
require 'java'
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9he.jar', __FILE__)
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9-unpack.jar', __FILE__)

java_import javax.xml.transform.stream.StreamSource 

module Saxon
  module S9API
    java_import 'net.sf.saxon.s9api.Processor'
    java_import 'net.sf.saxon.s9api.XdmDestination'
  end

  class Xslt
    def self.compile(xslt_path)
      new(xslt_path)
    end

    def initialize(xslt_path_or_io)
      @processor = S9API::Processor.new(false)
      @compiler = @processor.newXsltCompiler()
      @xslt = @compiler.compile(to_stream_source(xslt_path_or_io))
    end

    def transform(xml_path_or_io)
      output = S9API::XdmDestination.new
      xml = @processor.newDocumentBuilder().build(to_stream_source(xml_path_or_io))
      transformer = @xslt.load
      transformer.setInitialContextNode(xml)
      transformer.setDestination(output)
      transformer.transform
      output.getXdmNode
    end

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
