require 'saxon/xslt/version'
require 'java'
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9he.jar', __FILE__)
$CLASSPATH << File.expand_path('../../../vendor/saxonica/saxon9-unpack.jar', __FILE__)

java_import javax.xml.transform.stream.StreamSource 

module JavaIO
  include_package "java.io"
end

module Saxon
  module S9API
    java_import 'net.sf.saxon.s9api.Processor'
  end

  class Xslt
    def self.compile(xslt_path)
      new(xslt_path)
    end

    def initialize(xslt_path)
      @processor = S9API::Processor.new(false)
      @compiler = @processor.newXsltCompiler()
      @xslt = @compiler.compile(StreamSource.new(JavaIO::File.new(xslt_path)))
    end

    def transform(xml_path)
      serializer = @processor.newSerializer()
      output = JavaIO::StringWriter.new()
      serializer.setOutputWriter(output)
      xml = @processor.newDocumentBuilder().build(StreamSource.new(JavaIO::File.new(xml_path)))
      transformer = @xslt.load
      transformer.setInitialContextNode(xml)
      transformer.setDestination(output)
      transformer.transform
      output.toString
    end
  end
end
