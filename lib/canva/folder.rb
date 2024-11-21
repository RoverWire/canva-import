module Canva
  class Folder < Base
    attr_reader :default_folder

    def initialize
      super
      @default_folder = ENV.fetch('CANVA_FOLDER_ID')
    end

    def move_item(design_id, folder_id = nil)
      config_url('/v1/folders/move')
      folder_id ||= default_folder
      body = { to_folder_id: folder_id, item_id: design_id }

      request = Net::HTTP::Post.new(url)
      request['Authorization'] = authorization_bearer
      request['Content-Type'] = 'application/json'
      request.body = body.to_json

      http.request(request)
    end
  end
end
