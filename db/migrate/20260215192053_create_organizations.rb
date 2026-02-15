class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :company_name
      t.string :company_role
      t.string :localization
      t.string :job_title
      t.string :board
      t.string :department
      t.string :management
      t.string :area
      t.string :administration

      t.timestamps
    end
  end
end
