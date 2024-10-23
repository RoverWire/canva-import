namespace :template do
  desc 'Download templates to prepare upload'
  task :download do
    s3_client = S3Client.new
    import_device = ENV.fetch('DEVICE_NAME')

    Template.where(import_status: 'waiting').where("size < ?", 15).limit(5).find_each do |template|
      tmp_file = "./tmp/#{template.id}.psd"
      s3_file = "#{template.s3_key}document_0.psd"

      if s3_client.download_file(s3_file, tmp_file)
        params = { import_status: 'downloaded', import_device: }
        template.update!(params)
      end
    end
  end

  desc 'Upload templates to canva in batches'
  task :upload do
    # Time frame if token refresh
    sleep 2

    random = Random.alphanumeric
    batch_size = 5
    Template.where(import_status: 'downloaded')
            .limit(batch_size)
            .update_all(import_status: "taked #{random}")
    
    canva_import = Canva::Import.new

    Template.where(import_status:  "taked #{random}").limit(batch_size).find_each do |template|  
      tmp_file = "./tmp/#{template.id}.psd"

      next unless File.file?(tmp_file)

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
    end
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
