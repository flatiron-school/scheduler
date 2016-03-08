class AddSlugToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :slug, :string
  end
end
