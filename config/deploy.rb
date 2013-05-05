require 'bundler/capistrano'
require 'dotenv'
Dotenv.load

set :application, 'ceeker'
set :repository, ENV['CAP_REPOSITORY']
set :branch, ENV['CAP_BRANCH']

role :web, ENV['CAP_SERVER']
role :app, ENV['CAP_SERVER']
role :db, ENV['CAP_SERVER'], :primary => true

set :use_sudo, false
set :deploy_to, ENV['CAP_DEPLOY_TO']
set :deploy_via, :remote_cache
set :git_enable_submodules, true
set :git_shallow_clone, 1
set :scm_verbose, true
set :ssh_options, { :forward_agent => true }
set :bundle_without, [:development, :test]
set :normalize_asset_timestamps, false

after 'deploy:setup', 'deploy:setup_config'
after 'deploy:create_symlink', 'deploy:symlink_attachment'
namespace :deploy do
  task :setup_config, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} mkdir -p #{shared_path}/config"
  end

  task :symlink_attachment, :roles => :web, :except => { :no_release => true } do
    run "ln -fs #{shared_path}/config/.env #{current_path}/.env"
    run "ln -fs #{shared_path}/config/accounts.yml #{current_path}/config/accounts.yml"
  end
end

namespace :config do
  namespace :deploy do
    set :local_root_path, File.expand_path('../..', __FILE__)
    set :remote_config_path, "#{shared_path}/config"

    task :default, :roles => :web do
      transaction do
        on_rollback do
          run "rm -rf #{remote_config_path}"
          run "cp -rf #{remote_config_path}.prev #{remote_config_path}"
        end
        update
      end
    end

    task :update, :roles => :web do
      run "rm -rf #{remote_config_path}.prev"
      run "cp -rf #{remote_config_path} #{remote_config_path}.prev"
      upload("#{local_root_path}/.env", "#{remote_config_path}/.env", :via => :scp)
      upload("#{local_root_path}/config/accounts.yml", "#{remote_config_path}/accounts.yml", :via => :scp)
    end
  end
end
