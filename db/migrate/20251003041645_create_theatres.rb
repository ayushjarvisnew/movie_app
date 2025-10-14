class CreateTheatres < ActiveRecord::Migration[8.0]
  def change
    create_table :theatres do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.decimal :rating
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :theatres, :deleted_at
  end
end

