class Add < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :schedule_id, :integer
  end
end
