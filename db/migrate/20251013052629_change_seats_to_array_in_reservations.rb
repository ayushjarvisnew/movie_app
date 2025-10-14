class ChangeSeatsToArrayInReservations < ActiveRecord::Migration[8.0]
  def up
    # Convert existing integer seats to integer array
    execute <<-SQL
      ALTER TABLE reservations
      ALTER COLUMN seats
      TYPE integer[]
      USING ARRAY[seats];
    SQL

    # Set default to empty array
    change_column_default :reservations, :seats, []
  end

  def down
    # Convert back to single integer (take first element) for rollback
    execute <<-SQL
      ALTER TABLE reservations
      ALTER COLUMN seats
      TYPE integer
      USING seats[1];
    SQL
  end
end
