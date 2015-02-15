# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
path = File.expand_path("../", __FILE__)
require "dummy/config/environment"
require "rspec/rails"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
