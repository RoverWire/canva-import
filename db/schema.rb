# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_14_034320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configurations", force: :cascade do |t|
    t.text "canva_auth_code"
    t.text "canva_access_token"
    t.text "canva_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "is_elements", default: false
    t.json "stage_tags"
    t.json "device_tags"
    t.json "model_tags"
    t.json "bundle_tags"
    t.json "gender_tags"
    t.json "age_tags"
    t.json "ethnicity_tags"
    t.json "color_tags"
    t.json "invisible_tags"
    t.integer "category_id"
    t.string "category_name"
    t.boolean "is_published", default: false
    t.string "template_type"
    t.string "seo_title"
    t.text "stage_description"
    t.text "meta_description"
    t.integer "image_type_id"
    t.integer "custom_template_id"
    t.string "smart_template_id"
    t.string "smart_template_preset_id"
    t.string "nice_category"
    t.integer "object_id"
    t.string "s3_key"
    t.string "canva_design_id"
    t.string "import_status", default: "waiting"
    t.string "import_job_id"
    t.string "export_status"
    t.string "export_job_id"
    t.text "export_url"
    t.json "error_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
