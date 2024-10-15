module Canva
  class AuthUrl < Base
    attr_reader :code_challenge

    def initialize
      super
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
