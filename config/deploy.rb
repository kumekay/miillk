set :application, "guglor"

role :web, "kumekay.com"                          # Your HTTP server, Apache/etc
role :app, "kumekay.com"                          # This may be the same as your `Web` server
set :user, 'pipboy' # пользователь удалённого сервера
set :use_sudo, false # не запускать команды под sudo

set :app_dir, "/home/#{user}/#{application}/" # /home/myuser/myproject/
set :deploy_to, "#{app_dir}/deploy" # /home/myuser/myproject/deploy

# Настройки репозитория
set :scm, 'git'
set :scm_user, 'git' # имя пользователя репозитория
set :scm_url, "git@kumekay.com:guglor.git" 
# the rest should be good
set :repository,  "#{scm_user}@#{web}:git/#{application}.git" 
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
#  task :start do ; end
#  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run " touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end















