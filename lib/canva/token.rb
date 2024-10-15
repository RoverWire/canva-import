module Canva
  class Token < Base
    attr_reader :authorization
    attr_reader :content_type

    def initialize
      super
      load_configuration_values
      config_url('/v1/oauth/token')

      @authorization = authorization_header
      @content_type = 'application/x-www-form-urlencoded'
    end

    def generate
      request = ::Net::HTTP::Post.new(url)
      request['Authorization'] = authorization
      request['Content-Type'] = content_type
      request.body = body_generate

      http.request(request)
    end

    def refresh
      request = ::Net::HTTP::Post.new(url)
      request['Authorization'] = authorization
      request['Content-Type'] = content_type
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
