require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/processor'

module Saxon
  def self.XML(*args)
    Saxon::Processor.default.XML(*args)
  end

  module XML
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
