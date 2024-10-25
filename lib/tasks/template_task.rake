namespace :template do
  desc 'Download templates to prepare upload'
  task :download, [:batch_size, :max_size, :record_id] do |task, args|
    args.with_defaults(batch_size: 5, max_size: 30, record_id: nil)
    DownloadService.call(args[:batch_size], args[:max_size], args[:record_id])
  end

  namespace :download do
    desc 'Download an specific template referenced by template_id'
    task :id, [:record_id] do |task, args|
      Rake::Task['template:download'].invoke(1, 300, args[:record_id])
    end
  end

  desc 'Upload templates to canva in a batch'
  task :upload, [:batch_size] do |task, args|
    # Time frame if token refresh
    sleep 2
    args.with_defaults(batch_size: 5)
    UploadService.call(args[:batch_size])
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
