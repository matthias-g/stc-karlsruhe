set :application, 'servethecity-karlsruhe'
set :repo_url, 'git@github.com:matthias-g/stc-karlsruhe.git'

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
set :linked_files, %w{.env}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{log tmp/pids tmp/cache public/downloads public/uploads}

# Default value for default_env is {}
set :default_env, { path: "/package/host/localhost/ruby-2/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 20

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
  end
end
