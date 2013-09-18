require 'saxon/s9api'
require 'saxon/xslt'
require 'saxon/xml'

module Saxon
  class Processor
    def self.default
      @processor ||= new
    end

    def initialize
      @processor = S9API::Processor.new(false)
    end

    def XSLT(*args)
      Saxon::XSLT::Stylesheet.new(@processor, *args)
    end

    def XML(*args)
      Saxon::XML::Document.new(@processor, *args)
    end
  end
end
