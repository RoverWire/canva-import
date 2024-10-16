namespace :folder do
  desc 'Moves desing to a selected folder'
  task :move do
    canva_folder = Canva::Folder.new

    Template.where(import_status: 'success').limit(5).find_each do |template|
      response = canva_folder.move_item(template.canva_design_id)

      if response.code == '204'
        template.import_status = 'completed'
        template.export_status = 'waiting'
        template.save!
      end
    end
  end
end
