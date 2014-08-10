require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'
require 'saxon/xml'

module Saxon
  def self.XSLT(*args)
    Saxon::Processor.default.XSLT(*args)
  end

  module XSLT
    class Stylesheet
      def initialize(processor, string_or_io, opts = {})
        compiler = processor.newXsltCompiler()
        stream_source = SourceHelper.to_stream_source(string_or_io, opts)
        @xslt = compiler.compile(stream_source)
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
