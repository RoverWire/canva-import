namespace :folder do
  desc 'Moves desing to a selected folder from current device'
  task :move, [:batch_size, :check_all] do |task, args|
    # Time frame if token refresh
    sleep 2
    args.with_defaults(batch_size: 80, check_all: false)
    FolderMoveItemService.call(args[:batch_size], args[:check_all])
  end

  namespace :move do
    desc 'Moves desing to a selected folder from all devices'
    task :all, [:batch_size] do |task, args|
      Rake::Task['folder:move'].invoke(args[:batch_size], true)
    end
  end
end
