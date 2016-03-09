class AddWeekAndDayToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :week, :string
    add_column :schedules, :day, :string
  end
end
