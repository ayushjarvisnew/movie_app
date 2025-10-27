# class ChangeSeatIdsInBookingsToJson < ActiveRecord::Migration[8.0]
#   def change
#     # change_column :bookings, :seat_ids, :json, default: []
#     change_column :bookings, :seat_ids, 'json USING seat_ids::json', default: []
#   end
# end
class ChangeSeatIdsInBookingsToJson < ActiveRecord::Migration[8.0]
  def up
    # Convert text to json using raw SQL
    execute <<-SQL
      ALTER TABLE bookings
      ALTER COLUMN seat_ids TYPE json USING seat_ids::json;
    SQL

    # Set default to empty array
    change_column_default :bookings, :seat_ids, []
  end

  def down
    # Convert back to text if rolling back
    execute <<-SQL
      ALTER TABLE bookings
      ALTER COLUMN seat_ids TYPE text USING seat_ids::text;
    SQL

    change_column_default :bookings, :seat_ids, nil
  end
end
