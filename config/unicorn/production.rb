# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

listen 5876 # by default Unicorn listens on port 8080
worker_processes 12 # this should be >= nr_cpus
pid '/home/stc/servethecity-karlsruhe/current/tmp/pids/unicorn.pid'

# combine Ruby 2.0.0+ with "preload_app true" for memory savings
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end