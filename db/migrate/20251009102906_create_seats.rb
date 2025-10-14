class CreateSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :seats do |t|
      t.references :screen, null: false, foreign_key: true
      t.string :row, null: false
      t.string :seat_number, null: false
      t.string :seat_type, null: false, default: "Regular"
      t.decimal :price
      t.boolean :available, null: false, default: true
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :seats, :deleted_at
  end
end
