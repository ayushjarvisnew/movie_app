class RemoveSeatsFromReservations < ActiveRecord::Migration[7.1]
  def change
    # Only remove if it exists
    if column_exists?(:reservations, :seats)
      remove_column :reservations, :seats, :integer
    end
  end
end
