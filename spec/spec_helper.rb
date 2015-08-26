require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'vcr'

module FixtureHelpers
  def fixture_path(path)
    File.expand_path(File.join('../fixtures', path), __FILE__)
  end
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
