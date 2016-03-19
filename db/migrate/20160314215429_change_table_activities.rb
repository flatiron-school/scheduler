class ChangeTableActivities < ActiveRecord::Migration[5.0]
  def change
    remove_column :activities, :time
    add_column :activities, :start_time, :time
    add_column :activities, :end_time, :time
  end
end
