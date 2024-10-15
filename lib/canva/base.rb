module Canva
  class Base
    attr_reader :access_token
    attr_reader :app_scope
    attr_reader :auth_code
    attr_reader :client_id
    attr_reader :client_secret
    attr_reader :code_verifier
    attr_reader :redirect_uri
    attr_reader :refresh_token
    attr_reader :url

    def initialize
      @app_scope = ENV.fetch('CANVA_APP_SCOPE')
      @client_id = ENV.fetch('CANVA_CLIENT_ID')
      @client_secret = ENV.fetch('CANVA_CLIENT_SECRET')
      @code_verifier = ENV.fetch('CANVA_CODE_VERIFIER')
      @redirect_uri = ENV.fetch('CANVA_REDIRECT_URI')
    end

    protected

    def load_configuration_values
      record = Configuration.first
      @access_token = record.canva_access_token
      @auth_code = record.canva_auth_code
      @refresh_token = record.canva_refresh_token
    end

    def api_credentials
      Base64.strict_encode64("#{client_id}:#{client_secret}")
    end
  end
end
