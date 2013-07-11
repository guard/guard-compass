# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'guard/compass/version'

Gem::Specification.new do |s|
  s.name        = 'guard-compass'
  s.version     = Guard::CompassVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Guard gem for Compass'
  s.description = 'Guard::Compass automatically rebuilds scss|sass files when a modification occurs taking in account your compass configuration.'
  s.authors     = ['Olivier Amblet', 'Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'https://github.com/guard/guard-compass'

  s.add_dependency 'guard',   '>= 1.8'
  s.add_dependency 'compass', '>= 0.10.5'

  s.add_development_dependency 'bundler'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
