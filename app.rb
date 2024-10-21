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
    counters = { completed: 0, downloaded: 0, failed: 0, in_progress: 0, success: 0, waiting: 0, uploading: 0 }
    results = Template.select('import_status, COUNT(id) AS total').group(:import_status)

    results.each do |row|
      if row.import_status.include? 'taked '
        counters[:uploading] += row.total
      else
        counters[row.import_status.to_sym] += row.total
      end
    end

    counters
  end
end

##### Routes ######

get '/' do
  error_redirect(params[:error]) if params[:error]

  redirect '/token' if params[:code] && update_code(params[:code])

  erb :index
end

get '/dashboard' do
  @counters = get_stats
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
