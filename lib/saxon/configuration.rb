module Saxon
  # Wraps the <tt>net.saxon.Configuration</tt> class. See
  # http://saxonica.com/documentation9.5/javadoc/net/sf/saxon/Configuration.html
  # for details of what configuration options are available and what values
  # they accept. See
  # http://saxonica.com/documentation9.5/javadoc/net/sf/saxon/lib/FeatureKeys.html
  # for details of the constant names used to access the values
  class Configuration
    # @param processor [Saxon::Processor] a Saxon::Processor instance
    # @return [Saxon::Configuration]
    def self.create(processor = nil)
      if processor
        config = processor.to_java.underlying_configuration
      else
        config = Saxon::S9API::Configuration.new
      end
      new(config)
    end

    # @api private
    # @param config [net.sf.saxon.Configuration] The Saxon Configuration
    #   instance to wrap
    def initialize(config)
      @config = config
    end

    # Get a configuration option value
    # See http://saxonica.com/documentation9.5/javadoc/net/sf/saxon/lib/FeatureKeys.html
    # for details of the available options. Use the constant name as a string
    # or symbol as the option
    #
    # @param option [String, Symbol]
    # @return [Object] the value of the configuration option
    # @raise [NameError] if the option name does not exist
    def [](option)
      @config.getConfigurationProperty(option_url(option))
    end

    # Get a configuration option value
    # See http://saxonica.com/documentation9.5/javadoc/net/sf/saxon/lib/FeatureKeys.html
    # for details of the available options. Use the constant name as a string
    # or symbol as the option
    #
    # @param option [String, Symbol]
    # @param value [Object] the value of the configuration option
    # @return [Object] the value you passed in
    # @raise [NameError] if the option name does not exist
    def []=(option, value)
      @config.setConfigurationProperty(option_url(option), value)
    end

    # @return [net.sf.saxon.Configuration] The underlying Saxon Configuration
    def to_java
      @config
    end

    private

    def feature_keys
      @feature_keys ||= Saxon::S9API::FeatureKeys.java_class
    end

    def option_url(option)
      feature_keys.field(normalize_option_name(option)).static_value
    end

    def normalize_option_name(option)
      option.to_s.upcase
    end
  end
end
