module FixtureHelpers
  def fixture_path(path)
    File.expand_path(File.join('../fixtures', path), __FILE__)
  end
end

RSpec.configure do |c|
  c.include FixtureHelpers
end
