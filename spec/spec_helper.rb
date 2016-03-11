require 'capybara/rspec'
require 'omniauth'
require 'ostruct'
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OpenStruct.new(:uid => '1337',
    :provider => 'github',
    :info => OpenStruct.new(email: 'sophie@email.com'))

RSpec.configure do |config|
 
  config.expect_with :rspec do |expectations|
   
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  
  config.mock_with :rspec do |mocks|
   
    mocks.verify_partial_doubles = true
  end


  require 'factory_girl'
end

def sign_in
  visit '/'
  click_link "signin"
end
