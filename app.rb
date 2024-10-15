require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require 'base64'
require 'digest'
require 'uri'
require './lib/canva/auth_url'
require './lib/models'
require 'pry'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 3000
set :app_file, __FILE__
set :views, Proc.new { File.join(root, 'app', 'views') }

helpers do
  def update_code(code)
    return false unless code

    Configuration.first.update!(canva_auth_code: code)
  end
end

get '/' do
  redirect "/error?error=#{params[:error]}" if params[:error]

  redirect '/stats' if params[:code] && update_code(params[:code])

  erb :index
end

get '/auth' do
  auth_url = Canva::AuthUrl.new.generate
  redirect auth_url
end

get '/stats' do
  'Test!'
end

get '/error' do
  redirect '/' unless params[:error]

  @error = params[:error]
  erb :error
end
