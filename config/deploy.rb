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
set :repository, "git@github.com:ssbothwell/museumIndex.git"
set :scm_username, "ssbothwell"
ssh_options[:paranoid] = false
default_run_options[:pty] = true

# Passenger Integration

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:symlink", "deploy:update_crontab"
namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end
