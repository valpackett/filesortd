# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'filesortd/version'

Gem::Specification.new do |gem|
  gem.name          = "filesortd"
  gem.version       = Filesortd::VERSION
  gem.authors       = ["myfreeweb"]
  gem.email         = ["floatboth@me.com"]
  gem.description   = %q{Automatic rule-based sorting for your files. Like Hazel, but doesn't need a GUI.}
  gem.summary       = %q{Rule-based file sorting}
  gem.homepage      = "https://github.com/myfreeweb/filesortd"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "docile"
  gem.add_dependency "listen"
  gem.add_dependency "popen4"
  gem.add_dependency "thor"
end
