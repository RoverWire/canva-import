module Exports
  class StatusService < ApplicationService
    attr_reader :check_all

    def initialize(batch_size = 60, check_all = false)
      super
      @batch_size = batch_size
      @check_all = check_all
    end

    def call
      canva_export = Canva::Export.new
      Template.where(condition_array).limit(batch_size).each do |template|
        response = canva_export.get(template.export_job_id)
        process_export_response(response, template)
      end
    end

    private 
  
    def condition_array
      return ["export_status = ?", 'in_progress'] if check_all
  
      ["export_status = ? AND export_device = ?", 'in_progress', device_name]
    end
  end
end
