class CreateReservationsSeatsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations_seats, id: false do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
    end

    add_index :reservations_seats, [:reservation_id, :seat_id], unique: true
  end
end
