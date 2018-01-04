require 'pathname'
require 'java'

module Saxon
  # A sensible namespace to put Saxon Java classes into
  module S9API
  end

  module Loader
    LOAD_SEMAPHORE = Mutex.new

    # Error raised if Saxon::Loader.load! is called but the path handed
    # in does not exist or is not a directory
    class NoJarsError < StandardError
      def initialize(path)
        @path = path
      end

      def to_s
        "The path ('#{@path}') you supplied for the Saxon .jar files doesn't exist, sorry"
      end
    end

    # Error raised if Saxon::Loader.load! is called but the path handed
    # in does not contain the Saxon .jars
    class MissingJarError < StandardError
      def initialize(path)
        @path = path
      end

      def to_s
        "One of saxon9he.jar, saxon9pe.jar, or saxon9ee.jar must be present in the path ('#{@path}') you supplied, sorry"
      end
    end

    # @param saxon_home [String, Pathname] the path to the dir containing
    #   Saxon's .jars. Defaults to the vendored Saxon HE
    # @return [true, false] Returns true if Saxon had not been loaded and
    #   is now, and false if Saxon was already loaded
    def self.load!(saxon_home = File.expand_path('../../../vendor/saxonica', __FILE__))
      return false if @saxon_loaded
      LOAD_SEMAPHORE.synchronize do
        if Saxon::S9API.const_defined?(:Processor)
          false
        else
          if jars_not_on_classpath?
            saxon_home = Pathname.new(saxon_home)
            raise NoJarsError, saxon_home unless saxon_home.directory?
            jars = [main_jar(saxon_home)].compact
            raise MissingJarError if jars.empty?
            jars += extra_jars(saxon_home)

            add_jars_to_classpath!(saxon_home, jars)
          end
          import_classes_to_namespace!

          @saxon_loaded = true
          true
        end
      end
    end

    private

    def self.main_jar(path)
      ['saxon9he.jar', 'saxon9pe.jar', 'saxon9ee.jar'].map { |jar| path.join(jar) }.find { |jar| jar.file? }
    end

    def self.extra_jars(path)
      optional = ['saxon9-unpack.jar', 'saxon9-sql.jar'].map { |jar| path.join(jar) }.select { |jar| jar.file? }
      icu = path.children.find { |jar| jar.extname == '.jar' && !jar.basename.to_s.match(/^saxon-icu|^icu4j/).nil? }
      ([icu] + optional).compact
    end

    def self.jars_not_on_classpath?
      begin
        Java::net.sf.saxon.s9api.Processor
        false
      rescue
        true
      end
    end

    def self.add_jars_to_classpath!(saxon_home, jars)
      jars.each do |jar|
        $CLASSPATH << jar.to_s
      end
    end

    def self.import_classes_to_namespace!
      Saxon::S9API.class_eval do
        java_import 'net.sf.saxon.s9api.Processor'
        java_import 'net.sf.saxon.Configuration'
        java_import 'net.sf.saxon.lib.FeatureKeys'
        java_import 'net.sf.saxon.s9api.XdmNode'
        java_import 'net.sf.saxon.s9api.XdmNodeKind'
        java_import 'net.sf.saxon.s9api.XdmDestination'
        java_import 'net.sf.saxon.s9api.QName'
      end
    end
  end
end
