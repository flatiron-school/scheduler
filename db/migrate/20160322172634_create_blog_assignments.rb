class CreateBlogAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_assignments do |t|
      t.integer :schedule_id
      t.integer :student_id
      t.date :due_date
    end
  end
end
