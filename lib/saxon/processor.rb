require 'saxon/s9api'

module Saxon
  module Processor
    def self.default
      @processor ||= S9API::Processor.new(false)
    end
  end
end
