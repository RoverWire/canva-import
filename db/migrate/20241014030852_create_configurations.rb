class CreateConfigurations < ActiveRecord::Migration[7.2]
  def change
    create_table :configurations do |t|
      t.text :canva_auth_code
      t.text :canva_access_token
      t.text :canva_refresh_token
      t.timestamps null: false
    end
  end
end
