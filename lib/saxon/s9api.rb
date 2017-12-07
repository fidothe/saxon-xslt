require 'saxon/loader'

module Saxon
  module S9API
    def self.const_missing(name)
      Saxon::Loader.load!
      if const_defined?(name)
        const_get(name)
      else
        msg = "uninitialized constant Saxon::S9API::#{name}"
        e = NameError.new(msg, name)
        raise e
      end
    end
  end
end
