class ApplicationService
  attr_reader :batch_size
  attr_reader :device_name

  def initialize(...)
    @device_name = ENV.fetch('DEVICE_NAME')
  end

  def self.call(*, &)
    new(*, &).call
  end

  protected

  def process_response(response, record)
    body = JSON.parse(response.body)

    if response.code == '200' && body['job']['status'] != 'failed'
      record.import_status = body['job']['status']
      record.import_job_id = body['job']['id']
      record.canva_design_id = body['job']['result']['designs'][0]['id'] if body['job']['status'] == 'success'
    else
      record.import_status = 'failed'
      record.error_response = body
    end

    record.save!
  end

  def process_export_response(response, record)
    body = JSON.parse(response.body)

    if response.code == '200' && body['job']['status'] != 'failed'
      record.export_job_id = body['job']['id']
      record.export_status = body['job']['status']
      record.export_url = body['job']['urls'][0] if body['job']['status'] == 'success'
    else
      record.export_status = 'failed'
      record.error_response = body
    end

    record.save!
  end
end
