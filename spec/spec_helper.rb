# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'spec/custom_matcher'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.fixture_path = "#{::Rails.root}/spec/factories" 

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include(CustomMatchers)
end

module ApplicationSpecHelperMethods
  def should_load_categories
    category = mock_model(Category)
    @all_categories = { category.id => category }
    @root_categories = [ category ]
    controller.should_receive(:load_categories) do
      controller.instance_variable_set("@all_categories", @all_categories)
      controller.instance_variable_set("@root_categories", @root_categories)
    end.ordered
  end

  def should_authenticate_user
    @current_user = mock_model(User)
    controller.should_receive(:authenticate_user!)
    controller.stub!(:current_user).and_return(@current_user)
  end

  def should_authorize_resource
    controller.should_receive(:authorize!) 
  end

  private
  def mock_resource

  end
end

