require 'dotenv/load'
require 'sinatra'
require 'base64'
require 'digest'
require 'uri'
require './lib/canva/auth_url'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 3000
set :app_file, __FILE__

get '/' do
  'Hello world from Sinatra! '
end

get '/auth' do
  auth_url = Canva::AuthUrl.new.generate
  redirect auth_url
end
