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

  desc 'Get and update the status of import jobs from this device'
  task :status, [:batch_size, :check_all] do |task, args|
    # Time frame if token refresh
    sleep 2

    args.with_defaults(batch_size: 40, check_all: false)
    StatusService.call(args[:batch_size], args[:check_all])
  end

  namespace :status do
    desc 'Get and update the status of import jobs from all devices'
    task :all, [:batch_size] do |task, args|
      Rake::Task['template:status'].invoke(args[:batch_size], true)
    end
  end
end
