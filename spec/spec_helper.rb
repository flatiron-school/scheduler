require 'capybara/rspec'
require 'omniauth'
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = {
    :uid => '1337',
    :provider => 'github',
    :info => {
      :name => 'sophie'
    }
  }


RSpec.configure do |config|
 
  config.expect_with :rspec do |expectations|
   
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  
  config.mock_with :rspec do |mocks|
   
    mocks.verify_partial_doubles = true
  end


  require 'factory_girl'
end
