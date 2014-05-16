module Saxon
  java_import 'net.sf.saxon.Configuration'

  class Processor
    attr_accessor :configuration

    include Saxon::SourceHelpers

    def self.default
      @processor ||= new
    end

    ##
    # Initialize a Saxon S9API processor for transformations
    # @param [String,IO] configuration A Saxon configuration as kind of IO,
    # or the string path to the file.
    def initialize(configuration=nil)
      if configuration
        @configuration = Saxon::Configuration.readConfiguration(to_stream_source(configuration))
        @processor = S9API::Processor.new(@configuration)
      else
        @processor = S9API::Processor.new(false)
      end
    end

    def XSLT(*args)
      Saxon::XSLT::Stylesheet.new(@processor, *args)
    end

    def XML(*args)
      Saxon::XML::Document.new(@processor, *args)
    end
  end
end
