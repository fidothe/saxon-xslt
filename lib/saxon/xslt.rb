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
      # @param processor [Saxon::Processor] the Saxon processor object
      # @param string_or_io [File, IO, String] the input XSLT
      # @param opts [Hash] Stylesheet and input options
      # @return [Saxon::XSLT::Stylesheet] the compiled XSLT stylesheet
      def self.parse(processor, string_or_io, opts = {})
        source = processor.XML(string_or_io, opts)
        new(source)
      end

      # @param [Saxon::XML::Document] source the input XSLT as an XML document
      def initialize(source)
        processor = source.processor
        compiler = processor.to_java.new_xslt_compiler()
        @xslt = compiler.compile(source.to_java.as_source)
      end

      # Transform an input document
      # @param [Saxon::XML::Document] document the XML Document object to 
      #   transform
      # @return a Saxon::XML::Document object
      def transform(document)
        output = S9API::XdmDestination.new
        transformer = @xslt.load
        transformer.setInitialContextNode(document.to_java)
        transformer.setDestination(output)
        transformer.transform
        Saxon::XML::Document.new(output.getXdmNode)
      end
    end
  end
end
