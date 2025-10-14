class ChangeDefaultForSeatsAvailable < ActiveRecord::Migration[8.0]
  def change
    change_column_default :seats, :available, from: nil, to: true
    change_column_null :seats, :available, false, true
  end
end
