class CreateTableStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :github_username
      t.string :email
      t.string :blog_url
    end
  end
end
