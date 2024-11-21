module Canva
  class Import < Base
    def initialize
      super
    end

    def create(file_path, file_name, file_type = 'image/vnd.adobe.photoshop')
      import_metadata = { title_base64: ::Base64.strict_encode64(file_name), mime_ype: file_type }
      config_url('/v1/imports')
      request = ::Net::HTTP::Post.new(url)
      request['Authorization'] = authorization_bearer
      request['Content-Type'] = 'application/octet-stream'
      request['Import-Metadata'] = import_metadata.to_json
      request.body = File.read(file_path)

      http.request(request)
    end

    def get(job_id)
      config_url("/v1/imports/#{job_id}")
      request = ::Net::HTTP::Get.new(url)
      request['Authorization'] = authorization_bearer

      http.request(request)
    end
  end
end
