namespace :template do
  desc 'Download templates to prepare upload'
  task :download do
    DownloadService.call(5, 15)
  end

  desc 'Upload templates to canva in batches'
  task :upload do
    # Time frame if token refresh
    sleep 2

    UploadService.call(5)
  end

  desc 'Get and update the import job status'
  task :status do
    # Time frame if token refresh
    sleep 2

    canva_import = Canva::Import.new

    Template.where(import_status: 'in_progress').limit(60).find_each do |template|
      response = canva_import.get(template.import_job_id)

      next unless response.code == '200'

      body = JSON.parse(response.body)
      template.import_status = body['job']['status']
      template.import_job_id = body['job']['id']
      template.canva_design_id = body['job']['result']['designs'][0]['id'] if body['job']['status'] == 'success'

      template.error_response = body if body['job']['status'] == 'failed'

      template.save!
    end
  end
end
