require 'rails_helper'
require 'vcr'

VCR.configure do |c|  
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service. 
  c.ignore_localhost = true
  c.hook_into :webmock
  c.filter_sensitive_data('<OCTO_TOKEN>') { ENV['OCTO_TOKEN'] }
  c.filter_sensitive_data('<GOOGLE_CLIENT_ID') { ENV['GOOGLE_CLIENT_ID'] }
  c.filter_sensitive_data('<GOOGLE_CLIENT_SECRET') { ENV['GOOGLE_CLIENT_SECRET'] } 
  c.filter_sensitive_data('<GOOGLE_ACCESS_TOKEN') { ENV['TEST_GOOGLE_ACCESS_TOKEN'] }
  c.filter_sensitive_data('<GOOGLE_REFRESH_TOKEN') { ENV['TEST_GOOGLE_REFRESH_TOKEN'] }
end