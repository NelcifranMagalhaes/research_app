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

ActiveRecord::Schema[8.1].define(version: 2026_02_15_192135) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "employees", force: :cascade do |t|
    t.string "company_tenure"
    t.string "corporate_email"
    t.datetime "created_at", null: false
    t.string "gender"
    t.string "generation"
    t.string "name"
    t.string "personal_email"
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "administration"
    t.string "area"
    t.string "board"
    t.string "company_name"
    t.string "company_role"
    t.datetime "created_at", null: false
    t.string "department"
    t.string "job_title"
    t.string "localization"
    t.string "management"
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "theme"
    t.datetime "updated_at", null: false
  end

  create_table "survey_responses", force: :cascade do |t|
    t.date "answer_date"
    t.string "comment"
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "question_id", null: false
    t.integer "score"
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_survey_responses_on_employee_id"
    t.index ["organization_id"], name: "index_survey_responses_on_organization_id"
    t.index ["question_id"], name: "index_survey_responses_on_question_id"
  end

  add_foreign_key "survey_responses", "employees"
  add_foreign_key "survey_responses", "organizations"
  add_foreign_key "survey_responses", "questions"
end
