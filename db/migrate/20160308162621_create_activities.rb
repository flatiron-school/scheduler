class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.time :time
      t.string :description
      t.boolean :reserve_room, default: false
      t.timestamps
    end
  end
end
