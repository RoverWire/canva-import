class S3Client
  attr_reader :bucket_name
  attr_reader :client

  def initialize
    @bucket_name = ENV.fetch('S3_BUCKET_NAME')
    @client = Aws::S3::Resource
                .new
                .bucket(bucket_name)
  end

  def get_file(upload_path)
    s3_object = @client.object(upload_path).get
    s3_object.body
  end

  def download_file(key_path, local_path)
    @client.object(key_path).download_file(local_path)
  end

  def upload_file(upload_path, file_path, options)
    object = @client.object(upload_path)
    object.upload_file(file_path, options)

    object
  end
end
