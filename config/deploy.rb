# Application
set :application, "museumIndex"
set :deploy_to, "/home/ssbothwelladmin/museumindex.ssbothwell.com"

# Settings
set :use_sudo, false

# Server

role :app, "museumindex.ssbothwell.com"
role :web, "museumindex.ssbothwell.com"
role :db,  "museumindex.ssbothwell.com", :primary => true
set :user, "ssbothwelladmin"
set :use_sudo, false

# Git

set :scm, :git
set :repository, "git@github.com:ssbothwell/martinlubner.com.git"
set :scm_username, "ssbothwell"
set :scm_passphrase, "haskard"
ssh_options[:paranoid] = false
default_run_options[:pty] = true

# Passenger Integration

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."  
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"    
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"    
  end
  
end

after 'deploy:update_code', 'deploy:symlink_shared'