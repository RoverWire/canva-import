class AddSizeColumnToTemplates < ActiveRecord::Migration[7.2]
  def change
    add_column :templates, :size, :float, default: 0.0
  end
end
