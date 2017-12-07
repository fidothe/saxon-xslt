require 'vcr'
require 'simplecov'
SimpleCov.start

module FixtureHelpers
  def fixture_path(path)
    File.expand_path(File.join('../fixtures', path), __FILE__)
  end
end

if ENV['SAXON_PE'] && ['SAXON_LICENSE']
  require 'saxon/configuration'
  Saxon::Loader.load! ENV['SAXON_PE']
  licensed_config = Saxon::Configuration.create_licensed(ENV['SAXON_LICENSE'])
  Saxon::Configuration.set_licensed_default!(licensed_config)
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_hosts 'codeclimate.com'
end

RSpec.configure do |c|
  c.include FixtureHelpers
end
