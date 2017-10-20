# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-pinnings/version'

Gem::Specification.new do |spec|
  spec.name          = 'knife-pinnings'
  spec.version       = Knife::Pinnings::VERSION
  spec.authors       = ['Richard Nixon']
  spec.email         = ['richard.nixon@btinternet.com']
  spec.summary       = 'Chef knife plugin to set, list, compare, copy and delete cookbook pinnings across environments'
  spec.description   = 'Chef knife plugin to set, list, compare, copy and delete cookbook pinnings across environments'
  spec.homepage      = 'https://github.com/trickyearlobe/knife-pinnings'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  # rubocop:disable Style/RegexpLiteral
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0'
end
