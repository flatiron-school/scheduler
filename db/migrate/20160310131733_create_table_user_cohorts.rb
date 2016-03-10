class CreateTableUserCohorts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_cohorts do |t|
      t.integer :user_id
      t.integer :cohort_id
    end
  end
end
