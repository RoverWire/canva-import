namespace :token do
  desc 'Refresh the API access token'
  task :refresh do
    response = Canva::Token.new.refresh
    return false unless response.code == '200'

    body = JSON.parse(response.body)
    id = ENV.fetch('CONFIGURATION_ID', 1)
    Configuration.find(id).update!(canva_access_token: body['access_token'], canva_refresh_token: body['refresh_token'])
  end
end
