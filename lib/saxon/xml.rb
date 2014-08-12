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
      class << self
        def new(processor, string_or_io, opts = {})
          builder = processor.newDocumentBuilder()
          builder.build(SourceHelper.to_stream_source(string_or_io, opts))
        end
      end
    end
  end
end
