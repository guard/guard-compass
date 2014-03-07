# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/compass/version'

Gem::Specification.new do |s|
  s.name        = 'guard-compass'
  s.version     = Guard::CompassVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Olivier Amblet', 'Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'https://rubygems.org/gems/guard-compass'
  s.summary     = 'Guard plugin for Compass'
  s.description = 'Guard::Compass automatically rebuilds scss|sass files when a modification occurs taking in account your compass configuration.'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'guard',   '~> 2.0'
  s.add_runtime_dependency 'compass', '>= 0.10.5'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
