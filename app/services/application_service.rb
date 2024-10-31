class ApplicationService
  attr_reader :batch_size
  attr_reader :import_device

  def initialize(...)
    @import_device = ENV.fetch('DEVICE_NAME')
  end

  def self.call(*, &)
    new(*, &).call
  end

  protected

  def process_response(response, record)
    body = JSON.parse(response.body)

    if response.code == '200'
      record.import_status = body['job']['status']
      record.import_job_id = body['job']['id']
      record.canva_design_id = body['job']['result']['designs'][0]['id'] if body['job']['status'] == 'success'
      record.error_response = body if body['job']['status'] == 'failed'
    else
      record.import_status = 'failed'
      record.error_response = body
    end

    record.save!
  end
end
