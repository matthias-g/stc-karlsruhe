# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

listen 5876 # by default Unicorn listens on port 8080
worker_processes 12 # this should be >= nr_cpus
pid '/home/stc/servethecity-karlsruhe/current/tmp/pids/unicorn.pid'