class AddShaToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :sha, :string
  end
end
