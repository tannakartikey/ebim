require "bundler/setup"
require "aruba/rspec"
require "ebim"
require './spec/support/test_environment'

Aruba.configure do |config|
  config.allow_absolute_paths = true
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
