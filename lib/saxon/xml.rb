require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'

module Saxon
  def self.XML(string_or_io)
    Saxon::Processor.default.XML(string_or_io)
  end

  module XML
    class Document
      class << self
        def new(processor, string_or_io)
          builder = processor.newDocumentBuilder()
          builder.build(SourceHelper.to_stream_source(string_or_io))
        end
      end
    end
  end
end
