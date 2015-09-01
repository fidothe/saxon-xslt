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
      # @api private
      # @param processor [Saxon::Processor] the Saxon processor object
      # @param string_or_io [File, IO, String] the input XSLT
      # @param opts [Hash] Stylesheet and input options
      # @return [Saxon::XSLT::Stylesheet] the compiled XSLT stylesheet
      def self.parse(processor, string_or_io, opts = {})
        source = processor.XML(string_or_io, opts)
        new(source)
      end

      # Compile a stylesheet from an existing Saxon::XML instance of an XSLT
      # source
      #
      # @param document [Saxon::XML::Document] the input XSLT as an XML document
      # @return [Saxon::XSLT::Stylesheet] the compiled XSLT stylesheet
      def self.parse_stylesheet_doc(document)
        new(document)
      end

      # @param source [Saxon::XML::Document] the input XSLT as an XML document
      def initialize(source)
        processor = source.processor
        compiler = processor.to_java.new_xslt_compiler()
        @xslt = compiler.compile(source.to_java.as_source)
      end

      # Transform an input document
      #
      # To pass global parameters you can pass a hash with parameter names as
      # keys and values as XPath expressions as values: to pass a string value,
      # you need to pass it quoted: `"'string'"`. An unquoted string is an
      # XPath reference into the document being transformed.
      #
      # @param document [Saxon::XML::Document] the XML Document object to
      #   transform
      # @param params [Hash,Array] xsl params to set in the xsl document
      # @return [Saxon::XML::Document] the transformed XML Document
      def transform(document, params = {})
        output = S9API::XdmDestination.new
        transformer = @xslt.load
        transformer.setInitialContextNode(document.to_java)
        transformer.setDestination(output)
        set_params(transformer, document, params)
        transformer.transform
        Saxon::XML::Document.new(output.getXdmNode)
      end

      # Transform an input document and return the result as a string.
      #
      # See #transform for details of params handling
      # @param [Saxon::XML::Document] document the XML Document object to
      #   transform
      # @param params [Hash,Array] xsl params to set in the xsl document
      # @return [String] the transformed XML Document serialised to a string
      def apply_to(document, params = {})
        serialize(transform(document, params))
      end

      # Serialise a document to a string
      #
      # Not the most useful serialiser in the world. Provided for Nokogiri API
      # compatibility
      #
      # @param document [Saxon::XML::Document] the XML Document object to
      #   serialise
      # @return [String] the XML Document serialised to a string
      def serialize(document)
        document.to_s
      end

      private

      def set_params(transformer, document, params)
        case params
        when Hash
          params.each do |k,v|
            transformer.setParameter(S9API::QName.new(k.to_s), document.xpath(v))
          end
        when Array
          params.each_slice(2) do |k,v|
            raise ArgumentError.new("Odd number of values passed as params: #{params}") if v.nil?
            transformer.setParameter(S9API::QName.new(k.to_s), document.xpath(v))
          end
        end
      end
    end
  end
end
