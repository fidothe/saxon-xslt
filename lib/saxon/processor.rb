require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/xslt'
require 'saxon/xml'

module Saxon
  class Processor
    def self.default
      @processor ||= new
    end

    def initialize(config = nil)
      licensed_or_config_source = false
      if config
        licensed_or_config_source = Saxon::SourceHelper.to_stream_source(config)
      end
      @processor = S9API::Processor.new(licensed_or_config_source)
    end

    def XSLT(*args)
      Saxon::XSLT::Stylesheet.new(@processor, *args)
    end

    def XML(*args)
      Saxon::XML::Document.new(@processor, *args)
    end
  end
end
