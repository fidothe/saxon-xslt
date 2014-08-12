require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'
require 'saxon/xml'

module Saxon
  # Create an XSLT Stylesheet object using the default processor
  # @param input [File, IO, String] the input XSLT file
  # @param opts [Hash] options for the XSLT
  # @return [Saxon::XSLT::Stylesheet]
  def self.XSLT(input, opts = {})
    Saxon::Processor.default.XSLT(input, opts)
  end

  module XSLT
    # a Stylesheet transforms input (XML) into output
    class Stylesheet
      # @param processor [S9API::Processor] the Saxon processor object
      # @param string_or_io [File, IO, String] the input XSLT
      # @param opts [Hash] Stylesheet and input options
      def initialize(processor, string_or_io, opts = {})
        compiler = processor.newXsltCompiler()
        stream_source = SourceHelper.to_stream_source(string_or_io, opts)
        @xslt = compiler.compile(stream_source)
      end

      # Transform an input document
      # @param xdm_node the Saxon Document object to transform
      # @return a Saxon Document object
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
