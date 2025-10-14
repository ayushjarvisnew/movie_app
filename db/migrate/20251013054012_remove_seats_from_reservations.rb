class RemoveSeatsFromReservations < ActiveRecord::Migration[8.0]
  def change
    remove_column :reservations, :seats, :integer
  end
end
