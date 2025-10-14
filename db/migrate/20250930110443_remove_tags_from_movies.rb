class RemoveTagsFromMovies < ActiveRecord::Migration[8.0]
  def change
    remove_column :movies, :tags, :string
  end
end
