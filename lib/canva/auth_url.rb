module Canva
  class AuthUrl
    attr_reader :app_scope
    attr_reader :client_id
    attr_reader :code_challenge
    attr_reader :code_verifier
    attr_reader :redirect_uri

    def initialize
      @app_scope = ENV.fetch('CANVA_APP_SCOPE')
      @client_id = ENV.fetch('CANVA_CLIENT_ID')
      @code_verifier = ENV.fetch('CANVA_CODE_VERIFIER')
      @redirect_uri = ENV.fetch('CANVA_REDIRECT_URI')
    end

    def generate
      auth_url = "https://www.canva.com/api/oauth/authorize?code_challenge_method=s256&response_type=code"
      auth_url << "&client_id=#{client_id}"
      auth_url << "&redirect_uri=#{URI.encode_uri_component(redirect_uri)}"
      auth_url << "&scope=#{app_scope}"
      auth_url << "&code_challenge=#{code_challenge}"

      auth_url
    end

    private

    def process_code_challenge
      code =  Digest::SHA256.base64digest(code_verifier)
      @code_challenge = code.tr("+/", "-_").tr("=", "")
    end
  end
end
