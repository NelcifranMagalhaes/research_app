class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :personal_email
      t.string :gender
      t.string :generation
      t.string :corporate_email
      t.string :company_tenure

      t.timestamps
    end
  end
end
