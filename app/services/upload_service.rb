class UploadService < ApplicationService
  attr_reader :import_device
  attr_reader :random_string

  def initialize(batch_size = 5)
    super
    @batch_size = batch_size
    @random_string = Random.alphanumeric
  end

  def call
    mark_rows
    upload_files
  end

  private

  def mark_rows
    Template.where("import_status = ? AND import_device = ?", 'downloaded', import_device)
            .limit(batch_size)
            .update_all(import_status: "taked #{random_string}")
  end

  def upload_files
    canva_import = Canva::Import.new

    Template.where("import_status = ?", "taked #{random_string}").limit(batch_size).each do |template|
      tmp_file = "./tmp/#{template.id}.psd"
      next unless File.file?(tmp_file)

      response = canva_import.create(tmp_file, template.id.to_s)
      process_response(response, template)
      File.delete(tmp_file)
    end
  end
end
