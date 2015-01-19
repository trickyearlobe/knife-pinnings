# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-pinnings/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-pinnings"
  spec.version       = Knife::Pinnings::VERSION
  spec.authors       = ["Richard Nixon"]
  spec.email         = ["richard.nixon@btinternet.com"]
  spec.summary       = %q{Extends Chef's knife command to view cookbook pinnings across multiple environments.}
  spec.description   = %q{Extends Chef's knife command to view cookbook pinnings across multiple environments.}
  spec.homepage      = "https://github.com/trickyearlobe/knife-pinnings"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "chef", ">=11.10.4"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
