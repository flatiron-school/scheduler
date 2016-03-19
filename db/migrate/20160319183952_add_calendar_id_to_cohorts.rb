class AddCalendarIdToCohorts < ActiveRecord::Migration[5.0]
  def change
    add_column :cohorts, :calendar_id, :string
  end
end
