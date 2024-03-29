require "json_matchers/rspec"
require "simplecov"
require "sidekiq/testing"

ENV["RAILS_ENV"] ||= "test"

if ENV["CIRCLE_ARTIFACTS"]
  dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start "rails" if (ENV["CI"] || ENV["COVERAGE"])

JsonMatchers.schema_root = "spec/support/api/schemas"

Sidekiq::Testing.fake!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
