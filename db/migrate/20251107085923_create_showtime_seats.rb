class CreateShowtimeSeats < ActiveRecord::Migration[7.1]
  def change
    create_table :showtime_seats do |t|
      t.references :showtime, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.boolean :available, default: true

      t.timestamps
    end

    add_index :showtime_seats, [:showtime_id, :seat_id], unique: true
  end
end
