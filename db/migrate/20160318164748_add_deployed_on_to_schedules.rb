class AddDeployedOnToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :deployed_on, :datetime
  end
end
