namespace :token do
  desc 'Refresh the API access token'
  task :refresh do
    response = Canva::Token.new.refresh
    body = JSON.parse(response.body)

    if (response.code == '200')
      Configuration.first.update!(canva_access_token: body['access_token'], canva_refresh_token: body['refresh_token'])
    end
  end
end
