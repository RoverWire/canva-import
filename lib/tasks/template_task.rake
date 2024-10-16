namespace :template do
  desc 'Upload templates to canva in batches'
  task :upload do
    s3_client = S3Client.new
    canva_import = Canva::ImportJob.new

    Template.where(import_status: 'waiting').limit(5).find_each do |template|
      tmp_file = "./tmp/#{template.id}.psd"
      s3_file = "#{template.s3_key}document_0.psd"

      next unless s3_client.download_file(s3_file, tmp_file)

      response = canva_import.create(tmp_file, template.id.to_s)

      if response.code == '200'
        body = JSON.parse(response.body)
        template.import_status = body['job']['status']
        template.import_job_id = body['job']['id']
        template.canva_design_id = body['job']['result']['designs'][0]['id'] if body['job']['status'] == 'success'
      else
        template.import_status = 'failed'
        template.error_response = response.body
      end
      
      template.save!
      File.delete(tmp_file)
      sleep 1
    end
  end

  desc 'Get and update the import job status'
  task :status do
    canva_import = Canva::ImportJob.new

    Template.where(import_status: 'in_progress').limit(5).find_each do |template|
      response = canva_import.get(template.import_job_id)

      next unless response.code == '200'

      body = JSON.parse(response.body)
      template.import_status = body['job']['status']
      template.import_job_id = body['job']['id']
      template.canva_design_id = body['job']['result']['designs'][0]['id'] if body['job']['status'] == 'success'

      template.error_response = response.body if body['job']['status'] == 'failed'

      template.save!
      sleep 1
    end
  end
end
