redis_conn = proc {
  Redis.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
}
 
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
 
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
