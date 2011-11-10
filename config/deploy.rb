require "bundler/capistrano"
require 'new_relic/recipes'

set :application, "fluxqc"
set :repository, "git@github.com:kf8a/fluxqc.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "kalkaska.kbs.msu.edu"                          # Your HTTP server, Apache/etc
role :app, "kalkaska.kbs.msu.edu"                          # This may be the same as your `Web` server
role :db,  "kalkaska.kbs.msu.edu", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/u/apps/#{application}"

set :user, 'deploy'
set :use_sudo, false

#set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
set :branch, "master"
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true

set :unicorn_binary, "/usr/local/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "/var/u/apps/metadata/shared/pids/unicorn.pid"

namespace :deploy do
  desc "start unicorn appserves remote_file_exists?('/dev/null')"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && bundle exec  #{unicorn_binary}  -c #{unicorn_config} --env  #{rails_env} -D"
  end
  desc "stop unicorn appserver"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  desc "gracefully stop unicorn appserver"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    if remote_file_exists?(unicorn_pid) 
      run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
    end
  end
  desc "reload unicorn appserver"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  desc "restart unicorn appserver"
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
