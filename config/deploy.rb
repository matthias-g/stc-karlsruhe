set :application, 'servethecity-karlsruhe'
set :repo_url, 'https://github.com/matthias-g/stc-karlsruhe.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/servethecity-karlsruhe'
set :deploy_to, '/home/stc/servethecity-karlsruhe'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/master.key}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{log tmp/pids tmp/cache public/downloads public/uploads}

rubyversion = File.open('.ruby-version', &:readline).gsub(/\n/, '')
# Default value for default_env is {}
set :default_env, { path: "/home/stc/bin:/package/host/localhost/nodejs-8/bin:/package/host/localhost/#{rubyversion}/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
  end
end

# Number of delayed_job workers
# default value: 1
set :delayed_job_workers, 3
