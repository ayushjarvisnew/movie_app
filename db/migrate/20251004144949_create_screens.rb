class CreateScreens < ActiveRecord::Migration[8.0]
  def change
    create_table :screens do |t|
      t.references :theatre, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :total_seats, null: false
      t.string :screen_type
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :screens, :deleted_at
  end
end
