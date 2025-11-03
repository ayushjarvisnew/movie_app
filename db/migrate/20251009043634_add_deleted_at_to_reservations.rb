class AddDeletedAtToReservations < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:reservations, :deleted_at)
      add_column :reservations, :deleted_at, :datetime
    end
  end
end

