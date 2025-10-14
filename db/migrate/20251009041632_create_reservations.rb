class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :showtime, null: false, foreign_key: true
      t.integer :seats_count, null: false
      t.decimal :total_amount
      t.string :payment_status, null: false, default: "pending"
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :reservations, :deleted_at
  end
end
