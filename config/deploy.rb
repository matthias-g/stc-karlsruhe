require 'bundler/capistrano'
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'

server '31.47.252.208', :web, :app, :db, primary: true

set :application, 'serve_the_city_karlsruhe'
set :user, 'rails'
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, 'git@github.com:matthias-g/stc-karlsruhe.git'
set :branch, 'master'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup'
after 'deploy', 'deploy:migrate'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end