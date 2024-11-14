namespace :export do
  desc 'Create export process by batches or record id'
  task :create, [:batch_size, :record_id] do |task, args|
    # Time frame if token refresh
    # sleep 2
    args.with_defaults(batch_size: 15, record_id: nil)
    Exports::CreateService.call(args[:batch_size], args[:record_id])
  end

  namespace :create do
    desc 'Create a single export job referenced by template_id'
    task :id, [:record_id] do |task, args|
      Rake::Task['export:create'].invoke(1, args[:record_id])
    end
  end

  desc 'Check export job status from a batch'
  task :status, [:batch_size, :check_all] do |task, args|
    # Time frame if token refresh
    # sleep 2
    args.with_defaults(batch_size: 60, check_all: false)
    Exports::StatusService.call(args[:batch_size], args[:check_all])
  end

  namespace :status do
    desc 'Check export jobs from all devices'
    task :all, [:batch_size] do |task, args|
      Rake::Task['export:status'].invoke(args[:batch_size], true)
    end
  end

  desc 'Uploads the exported previews to S3'
  task :upload, [:batch_size] do |task, args|
    # Time frame if token refresh
    # sleep 2
    args.with_defaults(batch_size: 15)
    Exports::UploadService.call(args[:batch_size])
  end
end
