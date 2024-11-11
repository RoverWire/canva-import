class StatusService < ApplicationService
  attr_reader :check_all
  
  def initialize(batch_size = 60, check_all = false)
    super
    @batch_size = batch_size
    @check_all = check_all
  end

  def call
    canva_import = Canva::Import.new
    Template.where(condition_array).limit(batch_size).each do |template|
      response = canva_import.get(template.import_job_id)
      next unless response.code == '200'

      process_response(response, template)
    end
  end

  private 

  def condition_array
    return ["import_status = ?", 'in_progress'] if check_all

    ["import_status = ? AND import_device = ?", 'in_progress', device_name]
  end
end
