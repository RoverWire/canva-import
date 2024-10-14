require 'sinatra'
require 'dotenv/load'

set :environment, :development
set :bind, '0.0.0.0'
set :port, 3000
set :app_file, __FILE__

get '/' do
  'Hello world from Sinatra! '
end
