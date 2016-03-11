class CreateObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :objectives do |t|
      t.references :schedule, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
