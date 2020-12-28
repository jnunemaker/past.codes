# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'minitest/pride'
require 'sidekiq/testing'
require 'webmock/minitest'
require 'capybara/rails'
require 'capybara/minitest'
require 'minitest/mock_expectations'

Dir[Rails.root.join('test/support/**/*.rb')].sort.each { |f| require f }

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  Sidekiq::Testing.fake!

  WebMock.disable_net_connect!
end

class ActionDispatch::IntegrationTest
  include SignInHelper

  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

def stub_get_introspection_query
  stub_request(:post, 'https://api.github.com/graphql')
    .with(
      body: /query IntrospectionQuery/,
      headers: {
        'Authorization' => 'bearer token',
        'Content-Type' => 'application/json'
      }
    )
    .to_return(status: 200, body: file_fixture('dummy_introspection_response.json').read, headers: {})
end

def stub_get_starred_repos(res, pagination_query: false)
  stub_get_introspection_query

  query = if pagination_query
            /starredRepositories.+?"after":"Y3Vyc29yOnYyOpK5MjAyMC0xMi0wOVQxNDoyNDoyNCswMDowMM4O8QMK"/
          else
            /starredRepositories.+?"after":null/
          end

  stub_request(:post, 'https://api.github.com/graphql')
    .with(
      body: query,
      headers: {
        'Authorization' => 'bearer token',
        'Content-Type' => 'application/json'
      }
    )
    .to_return(status: 200, body: res, headers: {})
end
