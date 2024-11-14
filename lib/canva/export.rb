module Canva
  class Export < Base
    def initialize
      super
      load_configuration_values
    end

    def create(design_id, type = 'png', export_quality = 'regular')
      body = { design_id:, format: { type:, export_quality: } }

      config_url('/v1/exports')
      request = Net::HTTP::Post.new(url)
      request['Authorization'] = authorization_bearer
      request['Content-Type'] = 'application/json'
      request.body = body.to_json

      http.request(request)
    end

    def get(job_id)
      config_url("/v1/exports/#{job_id}")
      request = Net::HTTP::Get.new(url)
      request['Authorization'] = authorization_bearer

      http.request(request)
    end
  end
end
