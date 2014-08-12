require 'saxon/s9api'
require 'saxon/source_helper'
require 'saxon/xslt'
require 'saxon/xml'

module Saxon
  # Saxon::Processor wraps the S9API::Processor object. This is the object
  # responsible for creating an XSLT compiler or an XML Document object.
  #
  # The Processor is threadsafe, and can be shared between threads. But, most
  # importantly XSLT or XML objects created by a Processor can only be used
  # with other XSLT or XML objects created by the same Processor instance.
  class Processor
    # Provides a processor with default configuration. Essentially a singleton
    # instance
    # @return [Saxon::Processor]
    def self.default
      @processor ||= new
    end

    # @param config [File, String, IO] an open File, or string,
    #   containing a Saxon configuration file
    def initialize(config = nil)
      licensed_or_config_source = false
      if config
        licensed_or_config_source = Saxon::SourceHelper.to_stream_source(config)
      end
      @processor = S9API::Processor.new(licensed_or_config_source)
    end

    # @param input [File, IO, String] the input XSLT file
    # @param opts [Hash] options for the XSLT
    # @return [Saxon::XSLT::Stylesheet] the new XSLT Stylesheet
    def XSLT(input, opts = {})
      Saxon::XSLT::Stylesheet.new(@processor, input, opts)
    end

    # @param input [File, IO, String] the input XML file
    # @param opts [Hash] options for the XML file
    # @return [Saxon::XSLT::Stylesheet] the new XML Document
    def XML(input, opts = {})
      Saxon::XML::Document.new(@processor, input, opts)
    end
  end
end
