require 'rubygems'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

ENV['GUARD_ENV'] = 'test'
require 'guard/compass'

FIXTURES_PATH = Pathname.new(File.expand_path('../fixtures/', __FILE__))
LIB_PATH = Pathname.new(File.expand_path('../../lib/', __FILE__))
TMP_PATH = File.expand_path(File.dirname(__FILE__) + '/tmp_files')

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  $LOAD_PATH << LIB_PATH
end
