class CreateShowtimes < ActiveRecord::Migration[8.0]
  def change
    create_table :showtimes do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :screen, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :language, null: false
      t.integer :available_seats, null: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :showtimes, :deleted_at
  end
end
