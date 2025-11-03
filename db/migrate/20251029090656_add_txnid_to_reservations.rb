class AddTxnidToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :txnid, :string
  end
end
