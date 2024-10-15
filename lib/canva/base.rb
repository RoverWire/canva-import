module Canva
  class Base
    attr_reader :app_scope
    attr_reader :canva_access_token
    attr_reader :canva_auth_code
    attr_reader :canva_refresh_token
    attr_reader :client_id
    attr_reader :code_verifier
    attr_reader :redirect_uri

    def initialize
      @app_scope = ENV.fetch('CANVA_APP_SCOPE')
      @client_id = ENV.fetch('CANVA_CLIENT_ID')
      @code_verifier = ENV.fetch('CANVA_CODE_VERIFIER')
      @redirect_uri = ENV.fetch('CANVA_REDIRECT_URI')
    end

    protected

    def load_configuration_values
      record = Configuration.first
      @canva_access_token = record.canva_access_token
      @canva_auth_code = record.canva_auth_code
      @canva_refresh_token = record.canva_refresh_token
    end
  end
end
