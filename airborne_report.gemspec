# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'airborne_report/version'

Gem::Specification.new do |spec|
  spec.name          = 'airborne_report'
  spec.version       = AirborneReport::VERSION
  spec.authors       = ['Dmitry Efimov']
  spec.email         = ['d.efimov@fun-box.ru']

  spec.summary       = 'Generate reports on Airborne tests.'
  spec.description   =
    'This gem gives you RSpec formatters which let you generate HTML and JSON reports ' \
    'if you use the airborne gem for your integration tests.'

  spec.homepage      = 'https://github.com/funbox/airborne_report'
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
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'byebug'
end
