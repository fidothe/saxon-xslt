require 'saxon/s9api'
require 'saxon/source_helpers'
require 'saxon/processor'
require 'saxon/xml'

module Saxon
  def self.XSLT(xslt_path_or_io)
    XSLT::Stylesheet.new(xslt_path_or_io)
  end

  module XSLT
    class Stylesheet
      include Saxon::SourceHelpers

      def initialize(xslt_path_or_io)
        @processor = Saxon::Processor.default
        @compiler = @processor.newXsltCompiler()
        @xslt = @compiler.compile(to_stream_source(xslt_path_or_io))
      end

      def transform(xdm_node)
        output = S9API::XdmDestination.new
        transformer = @xslt.load
        transformer.setInitialContextNode(xdm_node)
        transformer.setDestination(output)
        transformer.transform
        output.getXdmNode
      end
    end
  end
end
