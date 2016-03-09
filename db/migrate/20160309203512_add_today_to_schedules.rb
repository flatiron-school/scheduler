class AddTodayToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :deploy, :boolean, default: true
  end
end
