require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'

set :env,  :production
disable :run

require 'guglor.rb'

run Sinatra::Application
