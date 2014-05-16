module Saxon
  def self.XML(string_or_io)
    Saxon::Processor.default.XML(string_or_io)
  end

  module XML
    class Document
      class << self
        include Saxon::SourceHelpers

        def new(processor, string_or_io, system_id = nil)
          builder = processor.newDocumentBuilder()
          builder.build(to_stream_source(string_or_io,system_id))
        end
      end
    end
  end
end
