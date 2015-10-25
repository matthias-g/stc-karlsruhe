# Set your full path to application.
app_path = '/home/stc/servethecity-karlsruhe/current'

# Set unicorn options
worker_processes 1
preload_app true
timeout 180
listen '127.0.0.1:5876'

# Spawn unicorn master worker for user stc (group: stc)
user 'stc', 'stc'

# Fill path to your app
working_directory '/home/stc/servethecity-karlsruhe/current'

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end