class AddLinkToScheduleActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :calendar_events, :link, :string
  end
end
