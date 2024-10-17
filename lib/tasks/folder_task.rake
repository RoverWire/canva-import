namespace :folder do
  desc 'Moves desing to a selected folder'
  task :move do
    # Time frame if token refresh
    sleep 5

    canva_folder = Canva::Folder.new

    Template.where(import_status: 'success').limit(80).find_each do |template|
      response = canva_folder.move_item(template.canva_design_id)

      if response.code == '204'
        template.import_status = 'completed'
        template.export_status = 'waiting'
        template.save!
      end

      sleep(0.5)
    end
  end
end
