namespace :token do
  desc 'Refresh the API access token'
  task :refresh, [:configuration_id] do |task, args|
    args.with_defaults(configuration_id: ENV.fetch('CONFIGURATION_ID', 1))
    response = Canva::Token.new(args[:configuration_id]).refresh

    if response.code == '200'
      body = JSON.parse(response.body)
      Configuration.find(args[:configuration_id])
                   .update!(canva_access_token: body['access_token'], canva_refresh_token: body['refresh_token'])
    else
      puts response.body
    end
  end
end
