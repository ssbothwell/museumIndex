# Application
set :application, "museumIndex"
set :deploy_to, "/var/rails/museumIndex"

# Settings
set :use_sudo, false

# Server

role :app, "208.88.125.40"
role :web, "208.88.125.40"
role :db,  "208.88.125.40", :primary => true
set :user, "capistrano"
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