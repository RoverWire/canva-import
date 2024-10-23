class AddMissingIndexes < ActiveRecord::Migration[7.2]
  def change
    add_index :templates, :canva_design_id, unique: true
    add_index :templates, :canva_folder_id
    add_index :templates, :import_status
    add_index :templates, :export_status
    add_index :templates, :import_device
    add_index :templates, :export_device
    add_index :templates, :size
  end
end
