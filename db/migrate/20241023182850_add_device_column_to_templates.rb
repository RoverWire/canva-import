class AddDeviceColumnToTemplates < ActiveRecord::Migration[7.2]
  def change
    add_column :templates, :import_device, :string
    add_column :templates, :export_device, :string
  end
end
