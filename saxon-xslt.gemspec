# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saxon/xslt/version'

Gem::Specification.new do |gem|
  gem.name          = "saxon-xslt"
  gem.version       = Saxon::Xslt::VERSION
  gem.authors       = ["Matt Patterson"]
  gem.email         = ["matt@reprocessed.org"]
  gem.description   = %q{Wraps the Saxon 9.4 HE XSLT 2.0 processor so that you can transform XSLT 2 stylesheets in JRuby}
  gem.summary       = %q{Saxon 9.4 HE XSLT 2.0 for JRuby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
