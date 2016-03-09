class CreateScheduleLabs < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_labs do |t|
      t.integer :schedule_id
      t.integer :lab_id
    end
  end
end
