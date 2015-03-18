worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true

LISTEN = ['staging', 'production'].include?(ENV['RAILS_ENV']) ? '/tmp/nginx.socket' : ENV.fetch('PORT').to_i
listen LISTEN

before_fork do |server, worker|
  FileUtils.touch('/tmp/app-initialized')

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  ActiveRecord::Base.establish_connection
end
