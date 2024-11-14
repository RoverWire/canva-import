module Exports
  class CreateService < ApplicationService
    attr_reader :record_id

    def initialize(batch_size = 15, record_id = nil)
      super
      @batch_size = batch_size
      @record_id = record_id
    end

    def call
      mark_rows
      create_jobs
    end

    private

    def mark_rows
      params = { export_status: 'initializing', export_device: device_name }
  
      Template.where(condition_array)
              .limit(batch_size)
              .update_all(params)
    end

    def condition_array
      return ["export_status = ? AND size >= ?", 'waiting', 200] unless record_id
  
      @batch_size = 1
      ["id = ?", record_id]
    end

    def create_jobs
      canva_export = Canva::Export.new
      Template.where("export_status = ? AND export_device = ?", 'initializing', device_name).limit(batch_size).each do |template|
        response = canva_export.create(template.canva_design_id)
        process_export_response(response, template)
      end
    end
  end
end
