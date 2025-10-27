class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :showtime, null: false, foreign_key: true
      # t.text :seat_ids
      t.json :seat_ids, default: []
      t.string :txnid
      t.string :status
      t.decimal :amount

      t.timestamps
    end
  end
end
