class AddCohortToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :cohort_id, :integer
  end
end
