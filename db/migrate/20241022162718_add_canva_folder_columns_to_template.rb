class AddCanvaFolderColumnsToTemplate < ActiveRecord::Migration[7.2]
  def change
    add_column :templates, :canva_folder_id, :string
    add_column :templates, :canva_folder_name, :string
  end
end
