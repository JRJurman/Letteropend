require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'letteropend'
