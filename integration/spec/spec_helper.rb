require "pry"
require "rspec/its"
require "ostruct"

require_relative "../../lib/jylis-rb"

Thread.abort_on_exception = true

RSpec.configure do |config|
  # Enable `should` syntax
  config.expect_with(:rspec) { |config| config.syntax = [:should, :expect] }
  config.mock_with(:rspec)   { |config| config.syntax = [:should, :expect] }
  
  # Only run tests marked with focus:true.
  # Enables use of fdescribe, fit, fspecify.
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
  
  # Abort after first failure.
  # (Use environment variable for developer preference)
  config.fail_fast = true if ENV["RSPEC_FAIL_FAST"]
  
  # Set output formatter and enable color.
  config.default_formatter = "Fivemat"
  config.color             = true
end
