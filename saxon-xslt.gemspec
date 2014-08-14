# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saxon/xslt/version'

Gem::Specification.new do |gem|
  gem.name          = "saxon-xslt"
  gem.version       = Saxon::XSLT::VERSION
  gem.authors       = ["Matt Patterson"]
  gem.email         = ["matt@reprocessed.org"]
  gem.description   = %q{Wraps the Saxon 9.5 HE XSLT 2.0 processor so that you can transform XSLT 2 stylesheets in JRuby. Sticks closely to the Nokogiri API}
  gem.summary       = %q{Saxon 9.5 HE XSLT 2.0 for JRuby with Nokogiri's API}
  gem.homepage      = "https://github.com/fidothe/saxon-xslt"
  gem.licenses      = ["MIT", "MPL-1.0"]
  gem.platform      = 'java'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rake', '~> 10.1')
  gem.add_development_dependency('rspec', '~> 3.0')
  gem.add_development_dependency('vcr', '~> 2.9.2')
  gem.add_development_dependency('webmock', '~> 1.18.0')
  gem.add_development_dependency('yard', '~> 0.8.7')
end
