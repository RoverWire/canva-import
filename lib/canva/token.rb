module Canva
  class Token < Base
    def initialize
      super
      load_configuration_values
      @url = URI('https://api.canva.com/rest/v1/oauth/token')
    end

    def generate
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['Authorization'] = "Basic #{api_credentials}"
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = body_generate

      http.request(request)
    end

    def refresh
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['Authorization'] = "Basic #{api_credentials}"
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = body_refresh

      http.request(request)
    end

    private

    def body_generate
      string = 'grant_type=authorization_code'
      string << "&redirect_uri=#{redirect_uri}"
      string << "&code=#{auth_code}"
      string << "&code_verifier=#{code_verifier}"

      string
    end

    def body_refresh
      string = 'grant_type=refresh_token'
      string << "&redirect_uri=#{redirect_uri}"
      string << "&refresh_token=#{refresh_token}"
      string << "&scope=#{app_scope}"

      string
    end
  end
end
