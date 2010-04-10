set :application, "guglor"

set :domain, 'kumekay.com'
set :user, 'pipboy' # пользователь удалённого сервера
set :use_sudo, false # не запускать команды под sudo

# Настройки репозитория
set :scm, 'git'
set :scm_user, 'git'
set :repository,  "#{scm_user}@#{domain}:#{application}.git" 
set :deploy_to, "/home/#{user}/#{application}"
# set :deploy_via, :remote_cache
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :runner, user
set :admin_runner, user
ssh_options[:forward_agent] = true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

role :web, domain
server domain , :web

namespace :deploy do
  task :start do ; end

  task :stop do ; end

  task :restart do
    run " touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :cold do
    deploy.update
    deploy.start
  end
end















