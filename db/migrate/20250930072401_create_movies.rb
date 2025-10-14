class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies, if_not_exists: true do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :poster_image
      t.date :release_date
      t.integer :duration          # in minutes
      t.string :tags               # comma-separated or use separate table later
      t.float :rating
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :movies, :deleted_at
  end
end
