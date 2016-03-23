class ChangeDefaultColumnActivities < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :reserve_room, :boolean, default: false
  end
end
