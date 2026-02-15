class CreateSurveyResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :survey_responses do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.date :answer_date
      t.integer :score
      t.string :comment

      t.timestamps
    end
  end
end
