class ChangeScheduleDeployFalse < ActiveRecord::Migration[5.0]
  def change
    change_column :schedules, :deploy, :boolean, default: false
  end
end
