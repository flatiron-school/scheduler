require 'vcr'
VCR.configure do |c|  
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service. 
  c.hook_into :webmock
  c.filter_sensitive_data('<OCTO_TOKEN>') { 'efaf4a4b1c0f47883fa3ce100fad48e51459e2c1' }
  c.filter_sensitive_data('<GOOGLE_CLIENT_ID') { '481920331604-4teqd1jj501e8cai2inklgo094a18efp.apps.googleusercontent.com' }
  c.filter_sensitive_data('<GOOGLE_CLIENT_SECRET') { '0C8F-p-D5Qv8k2kZfDf5urHa' } 
  c.filter_sensitive_data('<GOOGLE_ACCESS_TOKEN') { 'ya29.qQL2xp3t6UC9THBfNXYdss3gIjhPHgEgK3KHMHMpfqIs4AAhMgsPXJCEgqgbiZRVTQ' }
  c.filter_sensitive_data('<GOOGLE_REFRESH_TOKEN') { '1/lrauDufexJEGW4wwcv1saJ5lsyL8ZH9GZzdnLOAa9TY' }
end