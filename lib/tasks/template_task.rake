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

    StatusService.call(40)
  end
end
