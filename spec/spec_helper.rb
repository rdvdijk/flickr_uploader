if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'flickr_uploader'

require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

