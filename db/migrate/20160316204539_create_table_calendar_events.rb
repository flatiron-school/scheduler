class CreateTableCalendarEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :calendar_events do |t|
      t.integer :schedule_id
      t.string :name
      t.string :location
      t.datetime :reserved_at
      t.string :reserved_by
    end
  end
end
