namespace :folder do
  desc 'Moves desing to a selected folder'
  task :move, [:batch_size, :check_all] do |task, args|
    # Time frame if token refresh
    sleep 2
    args.with_defaults(batch_size: 80, check_all: false)
    FolderMoveItemService.call(args[:batch_size], args[:check_all])
  end
end
