class AddIndexToNameInCohorts < ActiveRecord::Migration[5.0]
  def change
    add_index :cohorts, :name
  end
end
