module Exports 
  class UploadService < ApplicationService
    attr_reader :random_string

    def initialize(batch_size = 15)
      super
      @batch_size = batch_size
      @random_string = Random.alphanumeric

      ::OpenURI::Buffer.send :remove_const, 'StringMax'
      ::OpenURI::Buffer.const_set 'StringMax', 0
    end

    def call
      mark_rows
      process_files
    end

    private

    def mark_rows
      Template.where("export_status = ? AND export_device = ?", 'success', device_name)
              .limit(batch_size)
              .update_all(export_status: "uploading #{random_string}")
    end

    def process_files
      s3_client = S3Client.new

      Template.where("export_status = ?", "uploading #{random_string}").limit(batch_size).each do |template|
        destination_path = "#{template.s3_key}export_preview.png"
        result = s3_client.upload_from_url(template.export_url, destination_path)
        next unless result.etag

        template.update!(export_status: 'completed')
      end
    end
  end
end
