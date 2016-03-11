class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.datetime :date
      t.text :notes
      t.timestamps
    end
  end
end
