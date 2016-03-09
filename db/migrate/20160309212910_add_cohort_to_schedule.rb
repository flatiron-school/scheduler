class AddCohortToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :cohort_id, :integer
  end
end
