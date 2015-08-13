require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'

module Saxon
  # Create an XML Document object using the default processor
  # @param input [File, IO, String] the input XML file
  # @param opts [Hash] options for the XML
  # @return [Saxon::XML::Document]
  def self.XML(input, opts = {})
    Saxon::Processor.default.XML(input, opts)
  end

  module XML
    # Parse an XML File or String into a Document object
    class Document
      # @api private
      # @param [Saxon::Processor] processor The processor object which should
      #   be used to build the document
      # @param [String, File, IO] string_or_io The input XML
      # @param [Hash] opts (see Saxon::SourceHelper#to_stream_source)
      # @return [Saxon::XML::Document]
      def self.parse(processor, string_or_io, opts = {})
        builder = processor.to_java.newDocumentBuilder()
        source = SourceHelper.to_stream_source(string_or_io, opts)
        xdm_document = builder.build(source)
        new(xdm_document)
      end

      # @param [String] expr The XPath expression to evaluate
      # @return [net.sf.saxon.s9api.XdmValue] return the value, node, or
      #   nodes selected
      def xpath(expr)
        processor.to_java.new_xpath_compiler.evaluate(expr, @xdm_document)
      end

      # @api private
      def initialize(xdm_document)
        @xdm_document = xdm_document
      end

      # @return [net.sf.saxon.s9api.XdmNode] return the underlying Saxon
      #   document object
      def to_java
        @xdm_document
      end

      # @return [String] return a simple serialisation of the document
      def to_s
        @xdm_document.to_s
      end

      # @return [Saxon::Processor] return the processor used to create this
      #   document
      def processor
        Saxon::Processor.new(@xdm_document.processor)
      end
    end
  end
end
