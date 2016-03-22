class AddRosterToCohorts < ActiveRecord::Migration[5.0]
  def change
    add_attachment :cohorts, :roster_csv
  end
end
