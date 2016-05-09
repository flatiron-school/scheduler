Billy.configure do |c|
  c.cache = true
  c.persist_cache = true
  c.cache_path = 'spec/req_cache/'
end
# need to call this because of a race condition between persist_cache
# being set and the proxy being loaded for the first time
Billy.proxy.reset_cache
