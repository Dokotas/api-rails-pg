class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
      t.string :place, null: false
      t.integer :company_id, null: false

      t.timestamps
    end
  end
end
