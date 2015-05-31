# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'special-one'
set :repo_url, 'git@github.com:ckrishna/special-one.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/special-one'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# linked_files = Set.new(fetch(:linked_files, [])) # https://github.com/capistrano/rails/issues/52
# linked_files.merge(%w{config/database.yml})
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
linked_dirs = Set.new(fetch(:linked_dirs, [])) # https://github.com/capistrano/rails/issues/52
linked_dirs.merge(%w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system})
# set :linked_dirs, linked_dirs.to_aset :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :finishing, :cleanup

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
