namespace :folder do
  desc 'Moves desing to a selected folder'
  task :move do
    # Time frame if token refresh
    sleep 3

    canva_folder = Canva::Folder.new
    canva_folder_id = ENV.fetch('CANVA_FOLDER_ID')
    canva_folder_name = ENV.fetch('CANVA_FOLDER_NAME')

    Template.where(import_status: 'success').limit(80).find_each do |template|
      response = canva_folder.move_item(template.canva_design_id, canva_folder_id)

      if response.code == '204'
        params = { import_status: 'completed', export_status: 'waiting', canva_folder_name:, canva_folder_id: }
        template.update!(params)
      end
    end
  end
end
