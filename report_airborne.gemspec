# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'report_airborne/version'

Gem::Specification.new do |spec|
  spec.name          = 'report_airborne'
  spec.version       = ReportAirborne::VERSION
  spec.authors       = ['d.efimov']
  spec.email         = ['d.efimov@fun-box.ru']

  spec.summary       = 'Generate report on tests.'
  spec.description   = 'Generate report on tests for gem airborne.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'airborne'
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'haml'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
