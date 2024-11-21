module Canva
  class Base
    attr_reader :access_token
    attr_reader :app_scope
    attr_reader :auth_code
    attr_reader :client_id
    attr_reader :client_secret
    attr_reader :code_verifier
    attr_reader :http
    attr_reader :redirect_uri
    attr_reader :refresh_token
    attr_reader :url

    API_BASE_URL = 'https://api.canva.com/rest'.freeze

    def initialize(avoid_load_configuration: false)
      @app_scope = ENV.fetch('CANVA_APP_SCOPE')
      @client_id = ENV.fetch('CANVA_CLIENT_ID')
      @client_secret = ENV.fetch('CANVA_CLIENT_SECRET')
      @code_verifier = ENV.fetch('CANVA_CODE_VERIFIER')
      @redirect_uri = ENV.fetch('CANVA_REDIRECT_URI')

      load_configuration_values unless avoid_load_configuration
    end

    protected

    def config_url(url)
      @url = URI("#{API_BASE_URL}#{url}")
      @http = ::Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
    end

    def load_configuration_values
      record = Configuration.find(ENV.fetch('CONFIGURATION_ID', 1))
      @access_token = record.canva_access_token
      @auth_code = record.canva_auth_code
      @refresh_token = record.canva_refresh_token
    end

    def authorization_basic
      "Basic #{api_credentials}"
    end

    def authorization_bearer
      "Bearer #{access_token}"
    end

    def api_credentials
      Base64.strict_encode64("#{client_id}:#{client_secret}")
    end
  end
end
