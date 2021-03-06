# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Requires Dojo shared examples.
Dir[Rails.root.join("spec/dojo/**/_examples/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

def last_by_update( repo )
  repo.records.values.sort { |a,b| a.last_updated <=> b.last_updated }.last
end

def last_by_creation( repo )
  repo.records.values.sort { |a,b| a.created_on <=> b.created_on }.last
end

def with_oauth_response( attr )
  auth_hash = { uid:         attr[:uid],
                provider:    attr[:provider],
                info:        { name:   attr[:name],
                               email:  attr[:email] } }

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = 
    OmniAuth::AuthHash.new( auth_hash )
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
end
