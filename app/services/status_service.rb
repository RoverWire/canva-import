class StatusService < ApplicationService
  
  def initialize(batch_size = 60)
    super
    @batch_size = batch_size
  end

  def call
    canva_import = Canva::Import.new
    Template.where("import_status = ? AND import_device = ?", 'in_progress', import_device).limit(batch_size).find_each do |template|
      response = canva_import.get(template.import_job_id)
      next unless response.code == '200'

      process_response(response, template)
    end
  end
end
