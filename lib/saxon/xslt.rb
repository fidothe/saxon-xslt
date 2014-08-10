require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'
require 'saxon/xml'

module Saxon
  def self.XSLT(string_or_io)
    Saxon::Processor.default.XSLT(string_or_io)
  end

  module XSLT
    class Stylesheet
      def initialize(processor, string_or_io)
        compiler = processor.newXsltCompiler()
        @xslt = compiler.compile(SourceHelper.to_stream_source(string_or_io))
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
