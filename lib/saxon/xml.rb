require 'saxon/s9api'
require 'saxon/source_helpers'

module Saxon
  class << self
    include Saxon::SourceHelpers

    def XML(string_or_io)
      processor = Saxon::Processor.default
      builder = processor.newDocumentBuilder()
      builder.build(to_stream_source(string_or_io))
    end
  end

  module XML
  end
end
