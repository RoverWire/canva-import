class DownloadService < ApplicationService
  attr_reader :file_size_limit
  attr_reader :import_device
  
  def initialize(batch_size = 5, size_limit = 100)
    super
    @batch_size = batch_size
    @file_size_limit = size_limit
  end

  def call
    mark_rows
    download_files
  end

  private

  def mark_rows
    params = { import_status: 'downloading', import_device: }

    Template.where("import_status = ? AND size < ?", 'waiting', file_size_limit)
            .limit(batch_size)
            .update_all(params)
  end

  def download_files
    s3_client = S3Client.new

    Template.where("import_status = ? AND import_device = ?", 'downloading', import_device).find_each do |template|
      tmp_file = "./tmp/#{template.id}.psd"
      s3_file = "#{template.s3_key}document_0.psd"

      if s3_client.download_file(s3_file, tmp_file)
        params = { import_status: 'downloaded' }
        template.update!(params)
      end
    end
  end
end
