class RemoveScheduleFromActivityAndLab < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :schedule_id
    remove_column :labs, :schedule_id
  end
end
