class CreateTemplatesTable < ActiveRecord::Migration[7.2]
  def change
    create_table :templates, id: false do |t|
      t.integer :id, primary_key: true
      t.string :name
      t.boolean :is_elements, default: false
      t.json :stage_tags
      t.json :device_tags
      t.json :model_tags
      t.json :bundle_tags
      t.json :gender_tags
      t.json :age_tags
      t.json :ethnicity_tags
      t.json :color_tags
      t.json :invisible_tags
      t.integer :category_id
      t.string :category_name
      t.boolean :is_published, default: false
      t.string :template_type
      t.string :seo_title
      t.text :stage_description
      t.text :meta_description
      t.integer :image_type_id
      t.integer :custom_template_id
      t.string :smart_template_id
      t.string :smart_template_preset_id
      t.string :nice_category
      t.integer :object_id
      t.string :s3_key
      t.timestamps null: false
    end
  end
end
