require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require './lib/canva'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 3000
set :app_file, __FILE__
set :views, Proc.new { File.join(root, 'app', 'views') }

helpers do
  def error_redirect(error)
    return false unless error

    redirect "/error?error=#{error}"
  end

  def update_code(code)
    return false unless code

    Configuration.first.update!(canva_auth_code: code)
  end

  def get_access_token
    response = Canva::Token.new.generate
    body = JSON.parse(response.body)

    redirect "/error?error=#{body['error_description']}" if body['error']

    Configuration.first.update!(canva_access_token: body['access_token'], canva_refresh_token: body['refresh_token'])
  end

  def get_stats
    @remaining = Template.where(import_status: 'waiting').count()
    @downloaded = Template.where(import_status: 'downloaded').count()
    @uploading = Template.where("import_status LIKE 'taked%'").count()
    @in_progress = Template.where(import_status: 'in_progress').count()
    @success = Template.where(import_status: 'success').count()
    @completed = Template.where(import_status: 'completed').count()
    @failed = Template.where(import_status: 'failed').count()
  end
end

##### Routes ######

get '/' do
  error_redirect(params[:error]) if params[:error]

  redirect '/token' if params[:code] && update_code(params[:code])

  erb :index
end

get '/dashboard' do
  get_stats
  erb :dashboard
end

get '/auth' do
  auth_url = Canva::AuthUrl.new.generate
  redirect auth_url
end

get '/token' do
  get_access_token

  erb :token
end

get '/error' do
  redirect '/' unless params[:error]

  @error = params[:error]
  erb :error
end
